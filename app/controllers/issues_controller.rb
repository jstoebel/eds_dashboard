class IssuesController < ApplicationController
  def new
  end

  def create

  end

  def show
  	@student = Student.find(params[:id])
  	name_details(@student)

  end
end
