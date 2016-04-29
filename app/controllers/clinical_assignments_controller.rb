# == Schema Information
#
# Table name: clinical_assignments
#
#  student_id          :integer          not null
#  id                  :integer          not null, primary key
#  clinical_teacher_id :integer          not null
#  Term                :integer          not null
#  CourseID            :string(45)       not null
#  Level               :string(45)
#  StartDate           :date
#  EndDate             :date
#
# Indexes
#
#  clinical_assignments_student_id_fk           (student_id)
#  fk_ClinicalAssignments_ClinicalTeacher1_idx  (clinical_teacher_id)
#

class ClinicalAssignmentsController < ApplicationController
  authorize_resource
  skip_authorize_resource :only => [:new, :choose]

  def index
    term_menu_setup
    @assignments = ClinicalAssignment.where(Term: @term).select {|a| can? :read, a }    #get records user can read

  end

  def new
    @assignment = ClinicalAssignment.new
    form_setup

  end

  def create

    @assignment = ClinicalAssignment.new
    @assignment.assign_attributes(assignment_params)

    begin
      start_date = Date.strptime(params[:clinical_assignment][:StartDate], '%d/%m/%Y')
      @assignment.StartDate = start_date 
    rescue ArgumentError => e
      @assignment.StartDate = nil
    end

    begin
      end_date = Date.strptime(params[:clinical_assignment][:EndDate], '%d/%m/%Y')
      @assignment.EndDate = end_date
    rescue ArgumentError => e
      @assignment.EndDate = end_date
    end

    #TODO ideally, look up student's courses dyanmically using ajax
    #plan b: look up all possible courses irrespective of student
    #plan c: text box (zzzz...)


    @assignment.CourseID = '???'    

    @assignment.Term = current_term({exact: false, plan_b: :forward}).BannerTerm
  
    authorize! :manage, @assignment

    if @assignment.save
      flash[:notice] = "Created Assignment: #{name_details(@assignment.student, file_as=true)} with #{@assignment.clinical_teacher.FirstName} #{@assignment.clinical_teacher.LastName}."
      redirect_to(clinical_assignments_path)
    else
      form_setup
      render ('new')
    end
      

  end

  def edit
    form_setup
    @assignment = ClinicalAssignment.find(params[:id])
    authorize! :manage, @assignment
  end

  def update

    @assignment = ClinicalAssignment.find(params[:id])
    authorize! :manage, @assignment
    @assignment.update_attributes(assignment_params)
    

    if @assignment.save
      flash[:notice] = "Updated Assignment #{name_details(@assignment.student, file_as=true)} with #{@assignment.clinical_teacher.FirstName} #{@assignment.clinical_teacher.LastName}."
      redirect_to(clinical_assignments_path)
    else
      form_details
      render ('new')
    end

  end

  def choose
  #display applicants for a term
  @term = params[:banner_term][:menu_terms]
  redirect_to(banner_term_clinical_assignments_path(@term))
  end

  private

  def assignment_params
    params.require(:clinical_assignment).permit(:student_id, :clinical_teacher_id, :Term, :CourseID, :Level, :StartDate, :EndDate)
    
  end
  def form_setup
    @students = Student.current.by_last.select{|s| can? :index, s}
    @teachers = ClinicalTeacher.all
    @current_term = current_term exact: false, plan_b: :forward
  end

end
