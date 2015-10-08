class AccessController < ApplicationController
  
	layout 'application'

  def index
  	@current_term = current_term({exact: false, plan_b: :forward})
  	
  end

  def login
  end
end
