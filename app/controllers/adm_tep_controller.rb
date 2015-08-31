class AdmTepController < ApplicationController
  
  layout 'application'

  def new
    #display menu for possible names and possible programs

    if current_term(exact=true) == nil
      flash[:notice] = "No Berea term is currently in session. You may not add a new student to apply."
      redirect_to(adm_tep_index_path)
      return
    end

    @students = Student.where("ProgStatus <> 'Candidate' and EnrollmentStatus='Active Student' and Classification <> 'Senior'")
    @programs = Program.where("Current = 1")

    @app = AdmTep.new
  end

  def create
 
    if current_term(exact=true) == nil
      flash[:notice] = "No Berea term is currently in session. You may not add a new student to apply."
      redirect_to(adm_tep_index_path)
    end

    @app = AdmTep.new(new_adm_params)
    @current_term = current_term(exact=true)    #we have already validated that we are inside a current term
    puts "*"*50
    puts @current_term
    @bnum =  params[:adm_tep][:Student_Bnum]
    @prog_code = params[:adm_tep][:Program_ProgCode]

    @app.BannerTerm_BannerTerm =  @current_term.BannerTerm
    @app.AppID = [@bnum, @current_term.BannerTerm.to_s, @prog_code].join('-')

    #TODO fetch GPA,  GPA last 30, earned credits. Add to @app

    if @app.save
      @student = Student.find(@bnum)
      name_details(@student)

      @program = Program.find(@prog_code)

      flash[:notice] = "New application added: #{@first_name}, #{@last_name}, #{@program.EDSProgName}"
      redirect_to(action: 'index')
    else
      flash[:notice] = "Application not saved."
      error_new
      
    end

  end

  def edit
      @application = AdmTep.where("AltID = ?", params[:id]).first
      @term = BannerTerm.find(@application.BannerTerm_BannerTerm)   #term of application
      @student = Student.find(@application.Student_Bnum)
      name_details(@student)

  end

  def update

    #process admission decision for student

    @application = AdmTep.where("AltID = ?", params[:id]).first

    @current_term = current_term(exact=false)

    #application must be processed in its own term or the break following.
    if @application.BannerTerm_BannerTerm != @current_term.BannerTerm
        flash[:notice] = "Application must be processed in its own term."
        error_update
        return
    end

    @application.TEPAdmit = string_to_bool(params[:adm_tep][:TEPAdmit])
    @application.letter = params[:adm_tep][:letter]
    @application.Notes = params[:adm_tep][:Notes]

    if @application.TEPAdmit == true
        begin
            admit_date = params[:adm_tep][:TEPAdmitDate]
            @application.TEPAdmitDate = DateTime.strptime(admit_date, '%m/%d/%Y') #load in the date if student was admited           
        rescue ArgumentError => e
            @application.TEPAdmitDate = nil
        end
        

    elsif @application.TEPAdmit.nil?
        flash[:notice] = "Please make an admission decision for this student."
        error_update
        return
    end

    if @application.save
        flash[:notice] = "Student application successfully updated"
        redirect_to(adm_tep_index_path)
        return

    else
        flash[:notice] = "Error in saving application."
        error_update
        return

    end

  end

  def index

    #@current_term: the current term in time
    #@term: the term displayed

    @current_term = current_term(exact_term=false)

    if params[:banner_term_id]
      @term = BannerTerm.find(params[:banner_term_id])   #ex: 201412

    else
      @term = @current_term   #if no params passed, the term to render is current term
    end
        
    @applications = AdmTep.all.by_term(@term)   #fetch all applications for this term

    #assemble possible terms for select menu 

    @menu_terms = BannerTerm.joins(:adm_tep).group(:BannerTerm).where("StartDate > ? and StartDate < ?", Date.today-730, Date.today)
    if (@current_term) and not (@menu_terms.include? @current_term)
      @menu_terms << @current_term    #add the current term if its not there already.
    end

  end

  def choose
    #display applicants for a term
    @term = params[:banner_term][:menu_terms]
    redirect_to(banner_term_adm_tep_index_path(@term))
    
  end

  def show
  end

  def download
    #download an admission letter
    app = AdmTep.where("AltId=?", params[:adm_tep_id]).first
    send_file app.letter.path
    
  end


  private
  def new_adm_params
    params.require(:adm_tep).permit(:Student_Bnum, :Program_ProgCode)
  end

  def edit_adm_params
    params.require(:adm_tep).permit(:TEPAdmit, :TEPAdmitDate)
  end

  def error_new
    #sends user back to new form

    @students = Student.where("ProgStatus <> 'Candidate' and EnrollmentStatus='Active Student' and Classification <> 'Senior'")
    @programs = Program.where("Current = 1")
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