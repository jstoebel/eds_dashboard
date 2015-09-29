class ProgExitsController < ApplicationController
  def index
  	term_menu_setup
  	@exits = ProgExit.all.by_term(@term)   #fetch all applications for this term

  end

  def show
  end

  def new
    puts "*************starting new controller!******************"
    @exit = ProgExit.new
    form_setup
    puts "***********here are the students!************"
    puts @students

  end

  def create
  end

  def choose
	  @term = params[:banner_term][:menu_terms]
	  redirect_to(banner_term_prog_exits_path(@term))
  end

  def get_programs
    #gets programs for a given student's B#
    @programs = Student.where(AltID: params[:alt_id]).first.programs
    
  end

  private

  def form_setup
    @students = Student.all.candidates.by_last
  end
end
