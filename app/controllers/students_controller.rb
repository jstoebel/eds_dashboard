class StudentsController < ApplicationController
  
  layout 'application'
  load_and_authorize_resource
  def index
  	@students = Student.all.current.by_last    #also need to filter for students who are activley enrolled.

  end

  def show
    1/0
    @student = Student.from_alt_id(params[:id])
  end

  def edit
  end

  def update
  end




end
