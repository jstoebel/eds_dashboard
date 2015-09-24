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
    @term = current_term(exact=true)


  end

  def create
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
    params.require(:clinical_site).permit(:SiteName, :City, :County, :Principal, :District)
    
  end
  def form_setup
    @students = Student.current.by_last
    @teachers = ClinicalTeacher.all
    @current_term = current_term
  end
end
