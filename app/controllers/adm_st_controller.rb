class AdmStController < ApplicationController
  
  layout 'application'

  def index
    #@current_term: the current term in time
    #@term: the term displayed

    @current_term = current_term(exact_term=false)

    if params[:banner_term_id]
      @term = BannerTerm.find(params[:banner_term_id])   #ex: 201412

    else
      @term = @current_term   #if no params passed, the term to render is current term
    end
        
    @applications = AdmSt.all.by_term(@term)   #fetch all applications for this term

    #assemble possible terms for select menu: all terms more than 
    #2 years ago, no future terms, and only terms with at least one 
    #application

    @menu_terms = BannerTerm.joins(:adm_st).group(:BannerTerm).where("StartDate > ? and StartDate < ?", Date.today-730, Date.today)
    # puts @menu_terms
    # puts @current_term

    if (@current_term) and not (@menu_terms.include? @current_term)
      @menu_terms << @current_term    #add the current term if its not there already.
    end
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

end
