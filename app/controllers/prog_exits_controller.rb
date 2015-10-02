class ProgExitsController < ApplicationController
  def index
  	term_menu_setup
  	@exits = ProgExit.all.by_term(@term)   #fetch all applications for this term

  end

  def show
  end

  def new
    @exit = ProgExit.new
    @students = Student.all.candidates.by_last
    @programs = []
    @exit_reasons = ExitCode.all
  end

  def create
    #mass assign bnum, program code, exit code, details
    @exit = ProgExit.new(exit_params)

    exit_date = params[:prog_exit][:ExitDate]
    if exit_date != ""
      @exit.ExitDate = DateTime.strptime(exit_date, '%m/%d/%Y')
    end

    recommend_date = params[:prog_exit][:RecommendDate]
    if recommend_date != ""
      @exit.RecommendDate = DateTime.strptime(recommend_date, '%m/%d/%Y')
    end
    #TODO compute GPA and GPA_last60
    @exit.GPA = 2.5
    @exit.GPA_last60 = 3.0

    #get exit ID
    @exit.ExitID = [@exit.Student_Bnum, @exit.Program_ProgCode, @exit.ExitTerm].join("-")

    if @exit.save?
      flash[:notice] = "Successfully exited #{name_details(@exit.student)} from #{@exit.program.EDSProgName}. Reason: #{@exit.exit_reason.ExitDiscrip}."
      redirect_to prog_exits_path
    else
      new_setup
      render('new')
      return
        
    end

  end

  def choose
	  @term = params[:banner_term][:menu_terms]
	  redirect_to(banner_term_prog_exits_path(@term))
  end

  def get_programs
    #gets programs for a given student's B#
    @programs = Student.where(AltID: params[:alt_id]).first.programs
    
    response = {}

    @programs.each do |p|   #build a hash with each program mapped to its id
      response.merge!({ p.ProgCode => p.EDSProgName })
    end

    render :json => response

  end

  private
  def exit_params
    params.require(:prog_exit).permit(:Student_Bnum, :Program_ProgCode, :ExitCode_ExitCode, :Details)
  end

  def new_setup
    @exit = ProgExit.new
    @students = Student.all.candidates.by_last
    @programs = []
    @exit_reasons = ExitCode.all
  end

end
