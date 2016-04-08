class PraxisResultsController < ApplicationController
  layout 'application'
  authorize_resource

  def index
    #showing all Praxis results for a single student
    @student = find_student(params[:student_id])
    ability = Ability.new(current_user)
    @tests = @student.praxis_results.select {|r| ability.can? :index, r }
    # @tests = @praxis_results #this should be created by load_and_authorize_resource
  end

  def show
    #show details on test including subtests
    @test = PraxisResult.find_by(:AltID => params[:id])
    authorize! :read, @test

    @student = Student.find(@test.student_id)
    authorize! :read, @student
    name_details(@student)
  end

  def new
    #for clerical users to enter a new praxis exam when a student registers.
    @test = PraxisResult.new
    form_setup
  end

  def create
    @test = PraxisResult.new(safe_params)
    stu = Student.find_by(AltID: params[:praxis_result][:AltID])
    authorize! :create, @test     #this should restrict advisors from adding new tests
    @test.student_id = stu.Bnum
    if @test.save
      @student = @test.student
      flash[:notice] = "Registration successful: #{info_for_flash}"
      redirect_to new_praxis_result_path
    else
      error_setup
      render 'new'
    end

  end

  def edit
    #update a praxis_result if no scores are present

    @test = PraxisResult.find_by(:AltID => params[:id])
    authorize! :update, @test
    if !@test.can_alter?
      flash[:notice] = "Test may not be altered."
      redirect_to student_praxis_results_path(@test.student.AltID)
    end
    form_setup

  end

  def update

    @test = PraxisResult.find_by(:AltID => params[:id])
    authorize! :update, @test
    if @test.update_attributes(safe_params)
      flash[:notice] = "Registration updated: #{info_for_flash}"
      redirect_to student_praxis_results_path(@test.student.AltID)
    else
      flash[:notice] = "Can't update test #{info_for_flash}"
      error_setup
      render 'edit'
    end
  end

  def delete
  end

  def destroy
    @test = PraxisResult.find_by(:AltID => params[:id])
    authorize! :destroy, @test
    @test.destroy
    redirect_to student_praxis_results_path(@test.student.AltID)
  end


  private

  def info_for_flash
    return "#{ApplicationController.helpers.name_details(@test.student)}, #{PraxisTest.find(@test.praxis_test_id).TestName}, #{@test.test_date.strftime("%m/%d/%Y")}"
  end

  def form_setup
    @students = Student.all.current.by_last
    @test_options = PraxisTest.all.current
  end

  def safe_params

    #same as using params[:subject] except that:
      #raises an error if :praxis_result is not present
      #allows listed attributes to be mass-assigned
    params.require(:praxis_result).permit(:praxis_test_id, :test_date, :reg_date, :paid_by)
    
  end

  def get_testid(params)
    result = params["praxis_result"]
    return [
        result[:AltID], 
        result[:praxis_test_id], 
        [
          result["TestDate(2i)"], result["TestDate(3i)"], result["TestDate(1i)"]
        ].join('/')
      ].join('-')
    
  end

  def error_setup
    #if we need to rerender edit or new, this sets up the needed instance variables.
    # flash[:notice] = "Error in creating registration. Please review this form and try again."
    @students = Student.all.current.by_last
    @test_options = PraxisTest.all.current
  end

end
