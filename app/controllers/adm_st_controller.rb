class AdmStController < ApplicationController
  
  layout 'application'

  def index
    #@current_term: the current term in time
    #@term: the term displayed

    @current_term = current_term(exact: false, plan_b: :back)

    if params[:banner_term_id]
      @term = BannerTerm.find(params[:banner_term_id])   #ex: 201412

    else
      @term = @current_term  #if no params passed, the term to render is current term
    end
        
    @applications = AdmSt.all.by_term(@term)   #fetch all applications for this term

    #assemble possible terms for select menu: all terms more than 
    #2 years ago, no future terms, and only terms with at least one 
    #application

    @menu_terms = BannerTerm.joins(:adm_st).group(:BannerTerm).where("StartDate > ? and StartDate < ?", Date.today-730, Date.today)
    # puts @menu_terms
    # puts @current_term

    if (@current_term) and not (@menu_terms.include? @current_term)
      @menu_terms << @current_term    #add the current term if its not there already.
    end
  end

  def show
    @app = AdmSt.where("AltID=?", params[:id]).first
    @term = BannerTerm.find(@app.BannerTerm_BannerTerm)
    @student = Student.find(@app.Student_Bnum)
    name_details(@student)
  end

  def new
    #display menu for possible names and possible programs

    if current_term(exact: true) == nil
      flash[:notice] = "No Berea term is currently in session. You may not add a new student to apply."
      redirect_to(adm_tep_index_path)
      return
    end

    # @students = Student.joins(:adm_tep).group(:Bnum).having(TEPAdmit: 1)

    @students = Student.where("ProgStatus = 'Candidate' and EnrollmentStatus='Active Student' and Classification='Senior'")
    @app = AdmSt.new
  end

  def create

    #can't add new students to apply once the term is over.
    
    @current_term = current_term(exact: true)

    if @current_term == nil
      flash[:notice] = "No Berea term is currently in session. You may not add a new student to apply."
      redirect_to(adm_tep_index_path)
    end

    @app = AdmSt.new(new_adm_params)    #add in Bnum

    @bnum =  params[:adm_st][:Student_Bnum]

    @app.BannerTerm_BannerTerm =  @current_term.BannerTerm
    @app.AppID = [@bnum, @current_term.BannerTerm.to_s].join('-')

    #TODO fetch overall GPA,  Core GPA, Add to @app

    if @app.save
      @student = Student.find(@bnum)
      name_details(@student)

      flash[:notice] = "New application added: #{@first_name} #{@last_name}"
      redirect_to(action: 'index')
    else
      flash[:notice] = "Application not saved."
      error_new
      
    end
  end

  def edit
    @application = AdmSt.where("AltID = ?", params[:id]).first
    @term = BannerTerm.find(@application.BannerTerm_BannerTerm)   #term of application
    @student = Student.find(@application.Student_Bnum)
    name_details(@student)
  end

  def update

    #process admission decision for student

    @application = AdmSt.where("AltID = ?", params[:id]).first

    @current_term = current_term(exact: false, plan_b: :back)

    #application must be processed in its own term or the break following.
    if @application.BannerTerm_BannerTerm != @current_term.BannerTerm
        flash[:notice] = "Application must be processed in its own term or the break following."
        error_update
        return
    end

    @application.STAdmitted = string_to_bool(params[:adm_st][:STAdmitted])
    @application.letter = params[:adm_st][:letter]
    @application.Notes = params[:adm_st][:Notes]

    #was an admission decision made?
    if @application.STAdmitted == true
        begin
            admit_date = params[:adm_st][:STAdmitDate]
            @application.STAdmitDate = DateTime.strptime(admit_date, '%m/%d/%Y') #load in the date if student was admited           
        rescue ArgumentError => e
            @application.STAdmitDate = nil
        end
        

    elsif @application.STAdmitted.nil?
        flash[:notice] = "Please make an admission decision for this student."
        error_update
        return
    end

    if @application.save
        flash[:notice] = "Student application successfully updated."
        redirect_to(adm_st_index_path)
        return

    else
        flash[:notice] = "Error in saving application."
        error_update
        return

    end

  end

  def download
    #download an admission letter
    app = AdmSt.where("AltId=?", params[:adm_st_id]).first
    send_file app.letter.path
    
  end

  def choose
  #display applicants for a term
  @term = params[:banner_term][:menu_terms]
  redirect_to(banner_term_adm_st_index_path(@term))
    
  end

  private
  def new_adm_params
    params.require(:adm_st).permit(:Student_Bnum)
  end

  def error_new
    #sends user back to new form

    @students = Student.where("ProgStatus = 'Candidate' and EnrollmentStatus='Active Student' and Classification='Senior'")
    render('new')
  end

  def error_update
    #sends user back to edit
    @term = BannerTerm.find(@application.BannerTerm_BannerTerm)
    @student = Student.find(@application.Student_Bnum)
    name_details(@student)
    render('edit')
    
  end
end
