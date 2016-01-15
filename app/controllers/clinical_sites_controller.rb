class ClinicalSitesController < ApplicationController
  authorize_resource
  skip_authorize_resource :only => [:new]

  def index
    @sites = ClinicalSite.all  #select {|r| can? :read, r }
  end

  # def show
  #   #show view not currently needed.
  # end

  def edit
    @site = ClinicalSite.find(params[:id])
    authorize! :read, @site

  end

  def update
    @site = ClinicalSite.find(params[:id])
    @site.update_attributes(site_params)

    authorize! :manage, @site
    if @site.save
      flash[:notice] = "Updated #{@site.SiteName}."
      redirect_to (clinical_sites_path)
    else
      flash[:notice] = "Error updating site."
      render 'edit'
      
    end
  end

  def new
    @site = ClinicalSite.new
  end

  def create
    @site = ClinicalSite.new
    @site.update_attributes(site_params)
    authorize! :manage, @site
    if @site.save
      flash[:notice] = "Created #{@site.SiteName}."
      redirect_to (clinical_sites_path)
    else
      flash[:notice] = "Error creating site."
      render 'new'
      
    end
  end

  private
  def site_params
    params.require(:clinical_site).permit(:SiteName, :City, :County, :Principal, :District)
    
    
  end

  def get_districts
    #get all preexisting districts
  end

  def get_counties
    #get all preexisting counties
  end
end
