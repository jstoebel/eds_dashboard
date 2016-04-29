# == Schema Information
#
# Table name: clinical_teachers
#
#  id               :integer          not null, primary key
#  Bnum             :string(45)
#  FirstName        :string(45)       not null
#  LastName         :string(45)       not null
#  Email            :string(45)
#  Subject          :string(45)
#  clinical_site_id :integer          not null
#  Rank             :integer
#  YearsExp         :integer
#

class ClinicalTeachersController < ApplicationController
  authorize_resource
  skip_authorize_resource :only => [:new]

  def index

    if params["clinical_site_id"]   #we only want teachers beloning to this site
      @teachers = ClinicalTeacher.where(clinical_site_id: params["clinical_site_id"]).select {|r| can? :read, r } 
    else
      @teachers = ClinicalTeacher.all  #.select {|r| can? :read, r } 
    end


  end

  def show
  end

  def edit
    form_details
    @teacher = ClinicalTeacher.find(params[:id])
    authorize! :manage, @teacher
  end

  def update
    @teacher = ClinicalTeacher.find(params[:id])
    @teacher.update_attributes(teacher_params)
    authorize! :manage, @teacher    
    if @teacher.save
      flash[:notice] = "Updated Teacher #{@teacher.FirstName} #{@teacher.LastName}."
      redirect_to(clinical_teachers_path)
    else
      form_details
      render ('edit')
    end

  end

  def new
    form_details
    @teacher = ClinicalTeacher.new

  end

  def create
    @teacher = ClinicalTeacher.new
    @teacher.update_attributes(teacher_params)
    authorize! :manage, @teacher
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
