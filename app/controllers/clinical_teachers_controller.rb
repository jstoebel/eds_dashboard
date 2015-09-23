class ClinicalTeachersController < ApplicationController
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
    @sites = ClinicalSite.all
  end

  def update
  end

  def new
    @teacher = ClinicalTeacher.new
    @sites = ClinicalSite.all
  end

  def create
    @teacher = ClinicalTeacher.new
    @teacher.update_attributes(teacher_params)
    if @teacher.save
      flash[:notice] = "Created new teacher #{@teacher.FirstName} + #{@teacher.LastName}."
    else
      @sites = ClinicalSite.all
      render ('new')
    end

  end

  private

def teacher_params
    params.require(:clinical_teacher).permit(:Bnum, :FirstName, :LastName, :Email, :Subject, :clinical_site_id, :Rank, :YearsExp)
  end
end
