class AdmTepController < ApplicationController
  def new
  end

  def create
  end

  def edit
    #TODO 
      #make sure user has permission to do this!
      #can't edit past term

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

    @current_term = current_term
    puts "*"*50
    puts @current_term
    #get the current term
    @term = BannerTerm.find(params[:banner_term_id])   #ex: 201412
    @applications = AdmTep.all.by_term(@term)

    @menu_terms = BannerTerm.joins(:adm_tep).group(:BannerTerm).where("StartDate > ? and StartDate < ?", Date.today-730, Date.today)
    
    if (@curent_term) and not (@menu_terms.include? @current_term)
      @menu_terms << @current_term    #add the current term if its not there already.
      
    end
  end

  def choose
    @term = params[:banner_term][:menu_terms]
    redirect_to(banner_term_adm_tep_index_path(@term))
    
  end

  def show
  end


  private
  def adm_params
    params.require(:adm_tep).permit(:TepAdmit, :TEPAdmitDate)
    
  end

end