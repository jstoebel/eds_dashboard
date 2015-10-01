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

    #insert dates. Don't know why these can't be mass assigned
    @exit.ExitDate = params[:prog_exit][:ExitDate]  
    @exit.ExitDate = params[:prog_exit][:RecommendDate]

    #TODO compute GPA and GPA_last60



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

end
