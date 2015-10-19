class AdmTepController < ApplicationController
  
  layout 'application'

  def new
    #display menu for possible names and possible programs

    if current_term(exact: true) == nil
      flash[:notice] = "No Berea term is currently in session. You may not add a new student to apply."
      redirect_to(adm_tep_index_path)
      return
    end

    @students = Student.where("ProgStatus = 'Prospective' and EnrollmentStatus not like 'Dismissed%' and EnrollmentStatus <> 'Graduation' and Classification <> 'Senior'")
    @programs = Program.where("Current = 1")
    @app = AdmTep.new
  end

  def create
    @current_term = current_term({exact: true})  
    if @current_term == nil
      flash[:notice] = "No Berea term is currently in session. You may not add a new student to apply."
      redirect_to(adm_tep_index_path)
    end

    @app = AdmTep.new(new_adm_params)

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
      return
      
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

    @current_term = current_term(exact: false)

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
    term_menu_setup
        
    @applications = AdmTep.all.by_term(@term)   #fetch all applications for this term

  end

  def choose
    #display applicants for a term
    @term = params[:banner_term][:menu_terms]
    redirect_to(banner_term_adm_tep_index_path(@term))
    
  end

  def show
    @app = AdmTep.where("AltID=?", params[:id]).first
    @term = BannerTerm.find(@app.BannerTerm_BannerTerm)
    @student = Student.find(@app.Student_Bnum)
    name_details(@student)
  end

  def download
    #download an admission letter
    app = AdmTep.where("AltId=?", params[:adm_tep_id]).first
    send_file app.letter.path
    #blah
    
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