class AdmTepController < ApplicationController
  def new
  end

  def create
  end

  def edit
    #TODO 
      #make sure user has permission to do this!
      #term must be current.

    @application = AdmTep.where(AltID: params[:id]).first

    @term = BannerTerm.find(@application.BannerTerm_BannerTerm)
    @student = @application.student
    name_details(@student)

  end

  def update
    @application = AdmTep.where(AltID: params[:id]).first
    if @application.update_attributes(adm_params)

      flash[:notice] = "Application successfully updated"
      redirect_to() #TODO complete this.

    end

  end

  def index

    #get the current term
    @term = current_term
    @applications = AdmTep.all.by_term(@term.BannerTerm)

  end

  def show
  end

  def decide

  end

  private
  def adm_params
    params.require(:adm_tep).permit(:TepAdmit, :TEPAdmitDate)
    
  end

end