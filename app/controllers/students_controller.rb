class StudentsController < ApplicationController
  
  layout false

  def index
  	@students = Student.all.current
  end

  def show
  end

  def edit
  end

  def update
  end
end
