class ProgExitsController < ApplicationController
  def index
  	term_menu_setup
  	@exits = ProgExit.all.by_term(@term)   #fetch all applications for this term

  end

  def show
  end

  def new
  end

  def create
  end

  def choose
	  @term = params[:banner_term][:menu_terms]
	  redirect_to(banner_term_prog_exits_path(@term))
  end
end
