class AccessController < ApplicationController
  def index
  	@current_term = current_term(exact=false)
  	
  end

  def login
  end
end
