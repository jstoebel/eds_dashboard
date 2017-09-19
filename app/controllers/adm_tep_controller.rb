class AdmTepController < ApplicationController

  layout 'application'
  authorize_resource
  load_resource :only => [:index]
  skip_authorize_resource :only => [:new, :choose]

  def new
    #display menu for possible names and possible programs
    @app = AdmTep.new
    authorize! :manage, @app
    @app.student_id = params[:student_id]
    new_setup
  end

  def create
    # create a new application
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

      flash[:info] = "New application added: #{name}-#{prog.EDSProgName}"
      redirect_to(action: 'index')
    else
      flash[:info] = "Application not saved."
      new_setup
      render ('new')
    end

  end

  def edit
      # edit an existing application
      @application = AdmTep.find(params[:id])
      authorize! :manage, @application
      @term = @application.banner_term
      @student =@application.student
      name_details(@student)
  end

  def update
    #process admission decision for student
    @application = AdmTep.find(params[:id])
    authorize! :manage, @application
    @current_term = BannerTerm.current_term(exact: false, :plan_b => :back)

    @application.TEPAdmit = string_to_bool(params[:adm_tep][:TEPAdmit])
    
    @application.Notes = params[:adm_tep][:Notes]

    # TODO: this logic should be handled in the model
    begin
      @application.TEPAdmitDate = params[:adm_tep][:TEPAdmitDate]
    rescue ArgumentError, TypeError => e
      Rails.logger.warn e.message
      Rails.logger.warn e.backtrace
      @application.TEPAdmitDate = nil
    end

    if @application.save
        flash[:info] = "Student application successfully updated"
        redirect_to banner_term_adm_tep_index_path(@application.banner_term.id)
        return

    else
        flash[:info] = "Error in saving application."
        error_update
        return
    end
  end

  def index
    # pull all applications and prepare term menu
    term_menu_setup(controller_name.classify.constantize.table_name.to_sym, :BannerTerm_BannerTerm)
    @applications = @adm_teps.by_term(@term)   #fetch all applications for this term

  end

  def choose
    #display applicants for a term
    @term = params[:banner_term][:menu_terms]
    redirect_to(banner_term_adm_tep_index_path(@term))
  end

  def destroy
    #method checks whether the record can be deleted, based upon value of TEPAdmit
    #calls destroy method if TEPAdmit does not have value
    @app = AdmTep.find(params[:id])    #find object and assign to instance variable
    authorize! :manage, @app
    
    # TODO: handle logic in the model
    if @app.TEPAdmit == nil            #if TEPAdmit does not have a value
      @app.destroy
      flash[:info] = "Record deleted successfully"
    else                               #if TEPAdmit does have a value
      flash[:info] = "Record cannot be deleted"    #notifies user that object cannot be deleted
    end
    redirect_to(banner_term_adm_tep_index_path(@app.BannerTerm_BannerTerm))    #method(method(object.attribute)) appropriate method found through routing page
  end

  private
  def new_adm_params
    # param safe listing
    params.require(:adm_tep).permit(:student_id, :Program_ProgCode, :BannerTerm_BannerTerm)
  end

  def edit_adm_params
    # param safe listing
    params.require(:adm_tep).permit(:TEPAdmit, :TEPAdmitDate)
  end

  def new_setup
      # general setup for new view. prepares students, programs and terms
      @students = Student.all.order(LastName: :asc).select { |s| s.prog_status == "Prospective" && s.EnrollmentStatus == "Active Student"}
      @programs = Program.where("Current = 1")
      @terms = BannerTerm.actual.where("StartDate >= ?", 1.year.ago).order(BannerTerm: :asc)
  end

  def error_update
    #sends user back to edit
    @term = BannerTerm.find(@application.BannerTerm_BannerTerm)
    @student = Student.find(@application.student_id)
    name_details(@student)
    render('edit')
  end

end
