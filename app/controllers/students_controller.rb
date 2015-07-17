class StudentsController < ApplicationController
  
  layout 'application'

  def index
  	@students = Student.all.current.by_last    #also need to filter for students who are activley enrolled.
  end

  def show
    @student = Student.find(params[:id])
  end

  def edit
  end

  def update
  end

  def show_praxis
    @student = Student.find(params[:id])
    
  end


end
