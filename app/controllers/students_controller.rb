class StudentsController < ApplicationController
  
  layout 'application'
  # load_and_authorize_resource
  authorize_resource
  def index
    user = current_user
  	@students = Student.all.current.by_last.select {|r| can? :index, r }    #also need to filter for students who are activley enrolled.
  end

  def show
    @student = Student.find_by(:AltID => params[:id])
    authorize! :show, @student
  end

  def edit
  end

  def update
  end

end
