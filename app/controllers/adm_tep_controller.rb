class AdmTepController < ApplicationController
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def index
    @term = BannerTerm.find(params[:banner_term_id])
    @applications = AdmTep.all.by_term(@term.BannerTerm)

  end

  def show
  end

end
