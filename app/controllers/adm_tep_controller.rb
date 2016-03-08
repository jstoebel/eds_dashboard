class AdmTepController < ApplicationController
  
  layout 'application'
  authorize_resource
  skip_authorize_resource :only => [:new, :choose]
  
  def new
    #display menu for possible names and possible programs

    if current_term(exact: true) == nil
      flash[:notice] = "No Berea term is currently in session. You may not add a new student to apply."
      redirect_to(adm_tep_index_path)
      return
    end
    @app = AdmTep.new
    new_setup
  end

  def create
    @current_term = current_term({exact: true})  
    if @current_term == nil
      flash[:notice] = "No Berea term is currently in session. You may not add a new student to apply."
      redirect_to(adm_tep_index_path)
      return
    end

    @app = AdmTep.new(new_adm_params)

    @bnum =  params[:adm_tep][:Student_Bnum]
    @prog_code = params[:adm_tep][:Program_ProgCode]

    @app.BannerTerm_BannerTerm =  @current_term.BannerTerm

    #how many times has this student applied this term?
    apps_this_term = AdmTep.where(Student_Bnum: @bnum).where(BannerTerm_BannerTerm: @app.BannerTerm_BannerTerm).where(Program_ProgCode: @app.Program_ProgCode).size
    @app.Attempt = apps_this_term + 1

    #TODO fetch GPA,  GPA last 30, earned credits. Add to @app
    @app.GPA = 3.0    #TODO FIX THIS!
    @app.GPA_last30 = 3.0   #TODO FIX THIS!
    @app.EarnedCredits = 45   #TODO FIX THIS!

    if @app.save
      @student = Student.find(@bnum)
      name = name_details(@student)

      @program = Program.find(@prog_code)

      flash[:notice] = "New application added: #{name}-#{@program.EDSProgName}"
      redirect_to(action: 'index')
    else
      flash[:notice] = "Application not saved."
      new_setup
      render ('new')
    end

  end

  def edit
      @application = AdmTep.find(params[:id])
      @term = BannerTerm.find(@application.BannerTerm_BannerTerm)   #term of application
      @student = Student.find(@application.Student_Bnum)
      name_details(@student)
  end

  def update
    #process admission decision for student
    @application = AdmTep.find(params[:id])
    @current_term = current_term(exact: false)

    #application must be processed in its own term or the break following.
    if @application.BannerTerm_BannerTerm != @current_term.BannerTerm
        flash[:notice] = "Application must be processed in its own term."
        error_update
        return
    end

    @application.TEPAdmit = string_to_bool(params[:adm_tep][:TEPAdmit])

    #assigns the letter if it was given. While this is admitadly verbose, I don't
    #know how to pass in a letter in my test request.

    @letter = StudentFile.create ({
        :doc => params[:adm_tep][:letter], 
        :active => true,
        :Student_Bnum => @application.student.id
      })
    @letter.save
    
    @application.student_file_id = @letter.id

    # @application.letter = params[:adm_tep][:letter] if params[:adm_tep][:letter].present?
    
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
        @letter.destroy!
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

    @app = AdmTep.find(params[:id])
    @term = BannerTerm.find(@app.BannerTerm_BannerTerm)
    @student = Student.find(@app.Student_Bnum)
    name_details(@student)
  end

  def download
    #download an admission letter
    app = AdmTep.find(params[:adm_tep_id])
    send_file app.student_file.doc.path
    
  end


  private
  def new_adm_params
    params.require(:adm_tep).permit(:Student_Bnum, :Program_ProgCode)
  end

  def edit_adm_params
    params.require(:adm_tep).permit(:TEPAdmit, :TEPAdmitDate)
  end


  def new_setup
      @students = Student.where("ProgStatus = 'Prospective' and EnrollmentStatus not like 'Dismissed%' and EnrollmentStatus <> 'Graduation' and Classification <> 'Senior'").order(LastName: :asc )
      @programs = Program.where("Current = 1")
  end
  # def error_new
  #   #sends user back to new form

  #   @students = Student.where("ProgStatus <> 'Candidate' and EnrollmentStatus='Active Student' and Classification <> 'Senior'")
  #   @programs = Program.where("Current = 1")
  #   render('new')
  # end

  def error_update
    #sends user back to edit
    @term = BannerTerm.find(@application.BannerTerm_BannerTerm)
    @student = Student.find(@application.Student_Bnum)
    name_details(@student)
    render('edit')
    
  end

end