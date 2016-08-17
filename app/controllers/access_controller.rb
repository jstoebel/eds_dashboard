class AccessController < ApplicationController

  layout 'application'
  skip_before_filter :authorize, :only => [:access_denied, :logout]   #don't need the authorize filter for these actions

  def index
    #users home page. Here they are shown options of where they can go next.
    #post: the current term and the user
  	@current_term = current_term({exact: false, plan_b: :forward})
    @user = current_user

  end

  def access_denied
		@env = request.env
  end

  def logout
    # reset_session
    session[:user] = nil
    session[:role] = nil
    session[:view_as] = nil
    redirect_to "/logout_confirm.html"
  end

  def change_psudo_status
    #if user is admin, change their :view_as status to the requested status
    if session[:role] == 'admin'
      session[:view_as] = params[:view_as].to_i
        redirect_to root_path
    else
      redirect_to "/access_denied"
    end

  end

end
