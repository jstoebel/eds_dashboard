
class FoiImportsController < ApplicationController
  def new
    @foi_import = FoiImport.new
  end

  def create
    @foi_import = FoiImport.new(params[:foi_import])
    if @foi_import.save
      redirect_to root_url, notice: "Imported forms of intention successfully."
    else
      render :new
    end
  end
end