class PraxisResultsController < ApplicationController
  layout 'application'
  authorize_resource
  # skip_authorize_resource :only => [:new]
  load_and_authorize_resource :only => [:index]

  def index
    #showing all Praxis results for a single student
    @student = find_student(params[:student_id])
    authorize! :read, @student
 
    ability = Ability.new(current_user)
    @tests = @student.praxis_results.select {|r| ability.can? :read, r }
    # @tests = @praxis_results #this should be created by load_and_authorize_resource
  end

  def show
    #show details on test including subtests
    @test = PraxisResult.find(params[:id])
    authorize! :read, @test

    @student = Student.find(@test.Bnum)
    authorize! :read, @student
    name_details(@student)
  end

  def new
    #for clerical users to enter a new praxis exam when a student registers.
    @test = PraxisResult.new

    @students = Student.all.current.by_last
    @test_options = PraxisTest.all.current
  end

  def create
    @test = PraxisResult.new(new_test_params)
    # @test.TestID = get_testid(params)
    @test.TestID = [@test.Bnum, @test.TestCode, @test.TestDate.strftime("%m/%d/%Y")].join("-")

    authorize! :manage, @test     #this should restrict advisors from adding new tests
    if @test.save
      # @student = Student.find(params[:praxis_result][:Bnum])
      @student = @test.student
      flash[:notice] = "Registration successful: #{ApplicationController.helpers.name_details(@student)}, #{@test.TestCode}, #{@test.TestDate}"
      redirect_to(action: 'new')
    else
      create_error
      
    end

  end


  private
  def new_test_params

    #same as using params[:subject] except that:
      #raises an error if :praxis_result is not present
      #allows listed attributes to be mass-assigned
    params.require(:praxis_result).permit(:Bnum, :TestCode, :TestDate, :RegDate, :PaidBy)
    
  end

  def get_testid(params)
    result = params["praxis_result"]
    return [
        result[:Bnum], 
        result[:TestCode], 
        [
          result["TestDate(2i)"], result["TestDate(3i)"], result["TestDate(1i)"]
        ].join('/')
      ].join('-')
    
  end

  def create_error
    #handles rerendernig of new page.
    # flash[:notice] = "Error in creating registration. Please review this form and try again."
    @students = Student.all.current.by_last
    @test_options = PraxisTest.all.current
    render('new')
  end

end
