class AdmStController < ApplicationController
  
  layout 'application'
  authorize_resource
  skip_authorize_resource :only => [:new, :choose]

  def index
    #@current_term: the current term in time
    #@term: the term displayed
    index_setup
  end

  def show
    @app = AdmSt.find(params[:id])   
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

    new_setup
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

    apps_this_term = AdmSt.where(Student_Bnum: @bnum).where(BannerTerm_BannerTerm: @app.BannerTerm_BannerTerm).size
    @app.Attempt = apps_this_term + 1

    #TODO fetch overall GPA,  Core GPA, Add to @app

    if @app.save
      @student = Student.find(@bnum)
      name_details(@student)

      flash[:notice] = "New application added for #{name_details(@student, file_as=true)}"
      redirect_to(action: 'index')
    else
      flash[:notice] = "Application not saved."
      new_setup
      render 'new'
      
    end
  end

  def edit
    @application = AdmSt.find(params[:id])
    @term = BannerTerm.find(@application.BannerTerm_BannerTerm)   #term of application
    @student = Student.find(@application.Student_Bnum)
  end

  def update

    #process admission decision for student

    @application = AdmSt.find(params[:id])

    @current_term = current_term(exact: false, plan_b: :back)

    #application must be processed in its own term or the break following.
    if @application.BannerTerm_BannerTerm != @current_term.BannerTerm
        flash[:notice] = "Application must be processed in its own term or the break following."
        error_update
        return
    end

    @application.STAdmitted = string_to_bool(params[:adm_st][:STAdmitted])
    @application.letter = params[:adm_st][:letter]

    #special validation 

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

  def edit_st_paperwork
    @app = AdmSt.find(params[:adm_st_id])
    @student = @app.student
    @terms = BannerTerm.where("BannerTerm > ?", @app.BannerTerm_BannerTerm).where("BannerTerm < ?", 300000 ).order(:BannerTerm)
    
  end

  def update_st_paperwork
    #update st paperwork


    @app = AdmSt.find(params[:adm_st_id])

    #convert each param to an int and assign
    params_to_convert = [:background_check, :beh_train, :conf_train, :kfets_in, :STTerm]
    
    params_to_convert.each do |p|
      @app.assign_attributes({p => param_to_int(p)})
    end

    notes = params[:adm_st][:Notes]
    @app.Notes = notes

    if @app.STTerm == 0
      @app.STTerm = nil
    end

    @app.assign_attributes(:skip_val_letter => true)    #let's not validate for the letter.
    if @app.save
      flash[:notice] = "Record updated for #{name_details(@app.student, file_as=true)}"
      redirect_to adm_st_index_path
    else
      index_setup
      render 'index'
      # flash[:notice] = "Problem updating record for #{name_details(app.student)}"
      # redirect_to adm_st_index_path
    end

  end

  def download
    #download an admission letter
    app = AdmSt.find(params[:adm_st_id])
    send_file app.letter.path
    
  end

  def choose
  #display applicants for a term
  @term = params[:banner_term][:menu_terms]
  redirect_to(banner_term_adm_st_index_path(@term))
    
  end

  private

  def index_setup
    term_menu_setup
        
    @applications = AdmSt.all.by_term(@term)   #fetch all applications for this term  
  end

  def new_adm_params
    params.require(:adm_st).permit(:Student_Bnum)
  end

  # def st_paperwork_params
  #   #safe add params for ST_paperwork
  #   params.require(:adm_st).permit(:background_check, :beh_train, :conf_train, :kfets_in)
  # end

  def param_to_int(param)

    return params[:adm_st][param].to_i
    
  end

  def new_setup
    @students = Student.where("ProgStatus = 'Candidate' and EnrollmentStatus='Active Student' and Classification='Senior'").order(LastName: :asc)
  end

  def error_update
    #sends user back to edit
    @term = BannerTerm.find(@application.BannerTerm_BannerTerm)
    @student = Student.find(@application.Student_Bnum)
    render('edit')
    
  end
end
