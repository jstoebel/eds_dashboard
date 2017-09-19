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

class ClinicalAssignmentsController < ApplicationController
  authorize_resource
  skip_authorize_resource :only => [:new, :choose]

  def index
    term_menu_setup(controller_name.classify.constantize.table_name.to_sym, :Term)
    @assignments = ClinicalAssignment.where(Term: @term).select {|a| can? :read, a }    #get records user can read

  end

  def new
    @assignment = ClinicalAssignment.new
    form_setup
  end

  def create

    @assignment = ClinicalAssignment.new
    @assignment.assign_attributes(assignment_params)

    # TODO: handle all of this logic in the controller
    begin
      @assignment.StartDate = params[:clinical_assignment][:StartDate]

      term = BannerTerm.current_term({:exact => false,
        :plan_b => :forward,
        :date => @assignment.StartDate
        })
      @assignment.Term = term.id
    rescue ArgumentError, TypeError => e
      Rails.logger.warn e.message
      Rails.logger.warn e.backtrace
      @assignment.StartDate = nil
      @assignment.Term = nil
    end

    begin
      @assignment.EndDate = params[:clinical_assignment][:EndDate]
    rescue ArgumentError, TypeError => e
      Rails.logger.warn e.message
      Rails.logger.warn e.backtrace
      @assignment.EndDate = nil
    end

    authorize! :manage, @assignment

    if @assignment.save
      flash[:info] = "Created Assignment: #{name_details(@assignment.student, file_as=true)} with #{@assignment.clinical_teacher.FirstName} #{@assignment.clinical_teacher.LastName}."
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

  def destroy
    @assignment = ClinicalAssignment.find(params[:id])
    @assignment.destroy
    flash[:info] = "Deleted Sucessfully!"
    redirect_to(banner_term_clinical_assignments_path(@assignment.Term))
  end

  def update
    @assignment = ClinicalAssignment.find(params[:id])
    authorize! :manage, @assignment
    @assignment.assign_attributes(assignment_params)

    begin
      @assignment.StartDate = params[:clinical_assignment][:StartDate]
    rescue ArgumentError, TypeError => e
      Rails.logger.warn e.message
      Rails.logger.warn e.backtrace
      @assignment.StartDate = nil
    end

    begin
      @assignment.EndDate = params[:clinical_assignment][:EndDate]
    rescue ArgumentError, TypeError => e
      Rails.logger.warn e.message
      Rails.logger.warn e.backtrace
      @assignment.EndDate = nil
    end

    # TODO: handle this logic in model
    if @assignment.save
      flash[:info] = "Updated Assignment #{name_details(@assignment.student, file_as=true)} with #{@assignment.clinical_teacher.FirstName} #{@assignment.clinical_teacher.LastName}."
      redirect_to(banner_term_clinical_assignments_path(@assignment.banner_term.id))
    else
      form_setup
      render ('edit')
    end

  end

  def choose
    #display applicants for a term
    @term = params[:banner_term][:menu_terms]
    redirect_to(banner_term_clinical_assignments_path(@term))
  end

  private

  def assignment_params
    params.require(:clinical_assignment).permit(:student_id, :clinical_teacher_id, :transcript_id, :Level)
  end
  
  def form_setup
    # set up the new/edit form by determining which students go in menu.
    # defined as all students who are
      # Active students
      # enrolled in atleast one class this term or the term coming up
    
    this_term = BannerTerm.current_term :exact => false, :plan_b => :forward
    @students = Student
      .joins(:transcripts) # only want students with at least one course.
      .by_last
      .where(:students => {:EnrollmentStatus => "Active Student"},
        :transcript => {:term_taken => this_term.id})
      .distinct
      .current
      .select{|s| can? :index, s}

    @teachers = ClinicalTeacher
      .by_last
    @current_term = current_term exact: false, plan_b: :forward
  end

end
