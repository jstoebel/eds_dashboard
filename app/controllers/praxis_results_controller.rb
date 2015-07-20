class PraxisResultsController < ApplicationController

  layout 'application'

  def show
  	#showing all Praxis results for a single student
    @student = Student.find(params[:id])
  end

  def test_details
    #show details on test including subtests
    @test = PraxisResult.find(params[:id])
    @student = Student.find(@test.Bnum)
    @test_score = @test.TestScore
    name_details(@student)
  end

  def new
    #for clerical users to enter a new praxis exam when a student registers.
    @test = PraxisResult.new
    @students = Student.all.current.by_last
    @test_options = PraxisTest.all.current
  end

  def create
  end
end
