class AdmTepController < ApplicationController
  
  layout 'application'
  authorize_resource
  skip_authorize_resource :only => [:new, :choose]
  
  def new
    #display menu for possible names and possible programs

    @app = AdmTep.new
    new_setup
  end

  def create
    term_now = BannerTerm.current_term({:exact => false, :plan_b => :back})

    app = AdmTep.new(new_adm_params)

    stu = app.student

    bnum =  params[:adm_tep][:student_id]
    prog_code = params[:adm_tep][:Program_ProgCode]

    #how many times has this student applied this term?

    apps_this_term = AdmTep.where(student_id: bnum).where(BannerTerm_BannerTerm: app.BannerTerm_BannerTerm).where(Program_ProgCode: prog_code).size
    app.Attempt = apps_this_term + 1

    #TODO fetch GPA,  GPA last 30, earned credits. Add to @app
    app.GPA = stu.gpa
    app.GPA_last30 = stu.gpa({last: 30})
    app.EarnedCredits = 45   #TODO FIX THIS!

    if app.save

      name = name_details(stu)
      prog = app.program

      flash[:notice] = "New application added: #{name}-#{prog.EDSProgName}"
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
      @student = Student.find(@application.student_id)
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
        :student_id => @application.student.id
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
    @student = Student.find(@app.student_id)
    name_details(@student)
  end

  def download
    #download an admission letter
    app = AdmTep.find(params[:adm_tep_id])
    send_file app.student_file.doc.path
    
  end


  private
  def new_adm_params
    params.require(:adm_tep).permit(:student_id, :Program_ProgCode, :BannerTerm_BannerTerm)
  end

  def edit_adm_params
    params.require(:adm_tep).permit(:TEPAdmit, :TEPAdmitDate)
  end


  def new_setup
      @students = Student.all.order(LastName: :asc).select { |s| s.prog_status == "Prospective" && !s.EnrollmentStatus.include?("Dismissed") && s.EnrollmentStatus != "Gradiation" && s.Classification != "Senior"}

      @programs = Program.where("Current = 1")

      term_now = BannerTerm.current_term({:exact => false, :plan_b => :back})
      @terms = BannerTerm.actual.where("BannerTerm >= ?", term_now.id).order(BannerTerm: :asc)
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
    @student = Student.find(@application.student_id)
    name_details(@student)
    render('edit')
    
  end

end