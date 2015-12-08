class AccessController < ApplicationController
	
  layout 'application'
  skip_before_filter :authorize, :only => [:access_denied, :logout]   #don't need the authorize filter for these actions

  def index
    #users home page. Here they are shown options of where they can go next.
  	@current_term = current_term({exact: false, plan_b: :forward})
  end

  def access_denied
  end

  def logout
    reset_session
    redirect_to "https://log:out@edsdata.berea.edu"
  end


 
end
