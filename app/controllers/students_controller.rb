class StudentsController < ApplicationController
  
  layout 'application'
  # load_and_authorize_resource
  authorize_resource
  def index
  	@students = Student.all.current.by_last.with_prof(user_bnum)    #also need to filter for students who are activley enrolled.

  end

  def show
    @student = Student.from_alt_id(params[:id])
    authorize! :show, @student
  end

  def edit
  end

  def update
  end




end
