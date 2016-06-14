class AdmStController < ApplicationController
  
  layout 'application'
  authorize_resource
  # skip_authorize_resource :only => [:choose]

  def index
    index_setup
  end

  def new
    #display menu for possible names and possible programs

    if current_term(exact: true) == nil
      flash[:notice] = "No Berea term is currently in session. You may not add a new student to apply."
      redirect_to(adm_st_index_path)
      return
    end

    new_setup
    @app = AdmSt.new
  end

  def create
    #pre: a student's Bnum
    #post: 
      #an application is created
      #flash message generated
      #redirected to index 

    @current_term = current_term(exact: true)

    @app = AdmSt.new(new_adm_params)    #add in student_id

    stu_id =  params[:adm_st][:student_id]
    apps_this_term = AdmSt.where(student_id: @stu_id).where(BannerTerm_BannerTerm: @app.BannerTerm_BannerTerm).size
    @app.Attempt = apps_this_term + 1

    #TODO fetch overall GPA,  Core GPA, Add to @app

    if @app.save
      @student = Student.find(stu_id)
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
    @app = AdmSt.find(params[:id])
    @term = BannerTerm.find(@app.BannerTerm_BannerTerm)   #term of application
    @student = Student.find(@app.student_id)
  end

  def update
    @app = AdmSt.find(params[:id])
    @current_term = current_term(exact: false, plan_b: :back)
    @app.assign_attributes(update_adm_params)

    begin
      @app.STAdmitDate = params[:adm_st][:STAdmitDate]
    rescue ArgumentError, TypeError => e
      @app.STAdmitDate = nil
    end

    letter = StudentFile.create ({
        :doc => params[:adm_st][:letter], 
        :active => true,
        :student_id => @app.student.id
      })

    letter.save
    @app.student_file_id = letter.id

    if @app.save
      letter.save
      flash[:notice] = "Student application successfully updated."
      redirect_to(adm_st_index_path)      
    else
      flash[:notice] = "Error in saving application."
      error_update      
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
  
  def destroy
    @app = AdmSt.find(params[:id])
    
    if @app.STAdmitted== nil  
      @app.destroy
      flash[:notice] = "Deleted Sucessfully!"
      
    else 
      flash[:notice] = "Could not successfully delete record!"
    end
    redirect_to(banner_term_adm_st_index_path(@app.BannerTerm_BannerTerm))
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
    term_menu_setup(controller_name.classify.constantize.table_name.to_sym, :BannerTerm_BannerTerm)

    @applications = AdmSt.all.by_term(@term)   #fetch all applications for this term  
  end

  def new_adm_params
    params.require(:adm_st).permit(:student_id, :BannerTerm_BannerTerm)
  end

  def update_adm_params
    params.require(:adm_st).permit(:STAdmitted, :Notes)
  end

  # def st_paperwork_params
  #   #safe add params for ST_paperwork
  #   params.require(:adm_st).permit(:background_check, :beh_train, :conf_train, :kfets_in)
  # end

  def param_to_int(param)

    return params[:adm_st][param].to_i
    
  end

  def new_setup
    @students = Student.all.order(LastName: :asc).select { |s| s.prog_status == "Candidate" && !s.EnrollmentStatus.include?("Dismissed") && s.EnrollmentStatus != "Gradiation"}
    @terms = BannerTerm.actual.where("EndDate >= ?", 2.years.ago).order(BannerTerm: :asc)
  end

  def error_update
    #sends user back to edit
    @term = BannerTerm.find(@app.BannerTerm_BannerTerm)
    @student = Student.find(@app.student_id)
    render('edit')
    
  end
end
