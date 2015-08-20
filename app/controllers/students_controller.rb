class StudentsController < ApplicationController
  
  layout 'application'

  def index
  	@students = Student.all.current.by_last    #also need to filter for students who are activley enrolled.

  end

  def show
    puts "*"*50
    puts "Got here!"
    @student = find_student(params[:id])
  end

  def edit
  end

  def update
  end




end
