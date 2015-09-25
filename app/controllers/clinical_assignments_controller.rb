class ClinicalAssignmentsController < ApplicationController

  def index
    #@current_term: the current term in time
    #@term: the term displayed

    term_menu_setup

    @assignments = ClinicalAssignment.where(Term: @term)

  end

  def show
  end

  def new
    @assignment = ClinicalAssignment.new
    form_setup

  end

  def create

    @assignment = ClinicalAssignment.new
    @assignment.assign_attributes(assignment_params)

    begin
      start_date = Date.strptime(params[:clinical_assignment][:StartDate], '%m/%d/%Y')
      @assignment.StartDate = start_date 
    rescue ArgumentError => e
      @assignment.StartDate = nil
    end

    begin
      end_date = Date.strptime(params[:clinical_assignment][:EndDate], '%m/%d/%Y')
      @assignment.EndDate = end_date
    rescue ArgumentError => e
      @assignment.EndDate = end_date
    end

    #TODO ideally, look up student's courses dyanmically using ajax
    #plan b: look up all possible courses irrespective of student
    #plan c: text box (zzzz...)


    @assignment.CourseID = '???'    

    @assignment.Term = current_term({exact: false, plan_b: "forward"}).BannerTerm

    if @assignment.save
      flash[:notice] = "Created Assignment: #{name_details(@assignment.student, file_as=true)} with #{@assignment.clinical_teacher.FirstName} #{@assignment.clinical_teacher.LastName}."
      redirect_to(clinical_assignments_path)
    else
      form_setup
      render ('new')
    end
      

  end

  def edit
  end

  def update
  end

  def choose
  #display applicants for a term
  @term = params[:banner_term][:menu_terms]
  redirect_to(banner_term_clinical_assignments_path(@term))
  end

  private

  def assignment_params
    params.require(:clinical_assignment).permit(:Bnum, :clinical_teacher_id, :Term, :CourseID, :Level, :StartDate, :EndDate)
    
  end
  def form_setup
    @students = Student.current.by_last
    @teachers = ClinicalTeacher.all
    @current_term = current_term exact: false, plan_b: :forward
  end
end
