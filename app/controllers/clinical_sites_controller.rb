# == Schema Information
#
# Table name: clinical_sites
#
#  id           :integer          not null, primary key
#  SiteName     :string(45)       not null
#  City         :string(45)
#  County       :string(45)
#  Principal    :string(45)
#  District     :string(45)
#  phone        :string(255)
#  receptionist :string(255)
#  website      :string(255)
#  email        :string(255)
#

class ClinicalSitesController < ApplicationController
  authorize_resource

  def index
    @sites = ClinicalSite.all.select {|r| can? :read, r }
  end

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
    authorize! :manage, @site
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

  def delete
    @site = ClinicalSite.find(params[:clinical_site_id])
    authorize! :manage, @site
  end

  def destroy
    @site = ClinicalSite.find(params[:id])
    authorize! :manage, @site
    @site.destroy
    flash[:notice] = "Deleted Successfully"
    redirect_to(clinical_sites_path)
  end

  private
  def site_params
    params.require(:clinical_site).permit(:SiteName, :City, :County, :Principal, :District, :phone, :receptionist, :website, :email)

  end

  def get_districts
    #get all preexisting districts
  end

  def get_counties
    #get all preexisting counties
  end
end
