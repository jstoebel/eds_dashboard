class AdmTepController < ApplicationController

  layout 'application'
  authorize_resource
  load_resource :only => [:index]
  skip_authorize_resource :only => [:new, :choose]

  def new
    #display menu for possible names and possible programs

    @app = AdmTep.new
    authorize! :manage, @app
    new_setup
  end

  def create

    @app = AdmTep.new(new_adm_params)
    authorize! :manage, @app
    stu = @app.student

    bnum =  params[:adm_tep][:student_id]
    prog_code = params[:adm_tep][:Program_ProgCode]

    #how many times has this student applied this term?

    apps_this_term = AdmTep.where(student_id: bnum).where(BannerTerm_BannerTerm: @app.BannerTerm_BannerTerm).where(Program_ProgCode: prog_code).size
    @app.Attempt = apps_this_term + 1

    if @app.save

      name = name_details(stu)
      prog = @app.program

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
      authorize! :manage, @application
      @term = BannerTerm.find(@application.BannerTerm_BannerTerm)   #term of application
      @student = Student.find(@application.student_id)
      name_details(@student)
  end

  def update
    #process admission decision for student
    @application = AdmTep.find(params[:id])
    authorize! :manage, @application
    @current_term = BannerTerm.current_term(exact: false, :plan_b => :back)

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

    @application.Notes = params[:adm_tep][:Notes]

    begin
      @application.TEPAdmitDate = params[:adm_tep][:TEPAdmitDate]
    rescue ArgumentError, TypeError => e
      @application.TEPAdmitDate = nil
    end

    if @application.save
        flash[:notice] = "Student application successfully updated"
        redirect_to banner_term_adm_tep_index_path(@application.banner_term.id)
        return

    else
        flash[:notice] = "Error in saving application."
        @letter.destroy!
        error_update
        return
    end
  end

  def index
    term_menu_setup(controller_name.classify.constantize.table_name.to_sym, :BannerTerm_BannerTerm)
    @applications = @adm_teps.by_term(@term)   #fetch all applications for this term
 
  end

  def choose
    #display applicants for a term
    @term = params[:banner_term][:menu_terms]
    redirect_to(banner_term_adm_tep_index_path(@term))
  end

  def show
    @app = AdmTep.find(params[:id])
    authorize! :read, @app
    @term = BannerTerm.find(@app.BannerTerm_BannerTerm)
    @student = Student.find(@app.student_id)
    name_details(@student)
  end

  def download
    #download an admission letter
    app = AdmTep.find(params[:adm_tep_id])
    authorize! :read, app
    send_file app.student_file.doc.path

  end

  def destroy
    #method checks whether the record can be deleted, based upon value of TEPAdmit
    #calls destroy method if TEPAdmit does not have value
    @app = AdmTep.find(params[:id])    #find object and assign to instance variable
    authorize! :manage, @app
    if @app.TEPAdmit == nil            #if TEPAdmit does not have a value
      @app.destroy
      flash[:notice] = "Record deleted successfully"
    else                               #if TEPAdmit does have a value
      flash[:notice] = "Record cannot be deleted"    #notifies user that object cannot be deleted
    end
    redirect_to(banner_term_adm_tep_index_path(@app.BannerTerm_BannerTerm))    #method(method(object.attribute)) appropriate method found through routing page
  end

  private
  def new_adm_params
    params.require(:adm_tep).permit(:student_id, :Program_ProgCode, :BannerTerm_BannerTerm)
  end

  def edit_adm_params
    params.require(:adm_tep).permit(:TEPAdmit, :TEPAdmitDate)
  end

  def new_setup
      @students = Student.all.order(LastName: :asc).select { |s| s.prog_status == "Prospective" && s.EnrollmentStatus == "Active Student"}
      @programs = Program.where("Current = 1")
      term_now = BannerTerm.current_term({:exact => false, :plan_b => :back})
      @terms = BannerTerm.actual.where("BannerTerm >= ?", term_now.id).order(BannerTerm: :asc)
  end

  def error_update
    #sends user back to edit
    @term = BannerTerm.find(@application.BannerTerm_BannerTerm)
    @student = Student.find(@application.student_id)
    name_details(@student)
    render('edit')
  end

end
