class PraxisResultsController < ApplicationController
  load_and_authorize_resource
  layout 'application'

  def index
    #showing all Praxis results for a single student
    @student = find_student(params[:student_id])
    
  end
  def show
    #show details on test including subtests
    @test = find_praxis_result(params[:id])
    @student = Student.find(@test.Bnum)
    @test_score = @test.TestScore
    name_details(@student)
  end

  # def test_details
    # #show details on test including subtests
    # @test = PraxisResult.find(params[:id])
    # @student = Student.find(@test.Bnum)
    # @test_score = @test.TestScore
    # name_details(@student)
  # end

  def new
    #for clerical users to enter a new praxis exam when a student registers.
    @test = PraxisResult.new
    @students = Student.all.current.by_last
    @test_options = PraxisTest.all.current
    # puts "HERE IS @test_options", @test_options
  end

  def create
    @test = PraxisResult.new(new_test_params)
    @test.TestID = get_testid(params)


    if @test.save
      @student = Student.find(params[:praxis_result][:Bnum])
      name_details(@student)
      flash[:notice] = "Registration successful: #{@first_name}, #{@last_name}, #{@test.TestCode}, #{@test.TestDate}"
      redirect_to(action: 'new')
    else
      create_error
      
    end


      # begin
      #   name_details(Student.find(@test.Bnum))
      #   @test.save
      #   flash[:notice] = "Registration successful: #{@first_name}, #{@last_name}, #{@test.TestCode}, #{@test.TestDate}"
      #   redirect_to(action: 'new')        
      # rescue ActiveRecord::RecordNotFound
      #   create_error
      # rescue ActiveRecord::InvalidForeignKey 
      #   create_error
      # end

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
