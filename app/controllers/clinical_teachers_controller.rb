class ClinicalTeachersController < ApplicationController
  load_and_authorize_resource
  def index

    if params["clinical_site_id"]   #we only want teachers beloning to this site
      @teachers = ClinicalTeacher.where(clinical_site_id: params["clinical_site_id"])
    else
      @teachers = ClinicalTeacher.all
    end


  end

  def show
  end

  def edit
    form_details
    @teacher = ClinicalTeacher.find(params[:id])
  end

  def update
    @teacher = ClinicalTeacher.find(params[:id])
    @teacher.update_attributes(teacher_params)
    if @teacher.save
      flash[:notice] = "Updated Teacher #{@teacher.FirstName} #{@teacher.LastName}."
      redirect_to(clinical_teachers_path)
    else
      form_details
      render ('new')
    end

  end

  def new
    form_details
    @teacher = ClinicalTeacher.new

  end

  def create
    @teacher = ClinicalTeacher.new
    @teacher.update_attributes(teacher_params)
    if @teacher.save
      flash[:notice] = "Created new teacher #{@teacher.FirstName} #{@teacher.LastName}."
      redirect_to(clinical_teachers_path)
    else
      form_details
      render ('new')
    end

  end

  private

  def teacher_params
    params.require(:clinical_teacher).permit(:Bnum, :FirstName, :LastName, :Email, :Subject, :clinical_site_id, :Rank, :YearsExp)
  end

  def form_details
    @sites = ClinicalSite.all
    @subjects = Program.where(Current: true)
  end
end
