class AccessController < ApplicationController

  layout 'application'
  skip_before_filter :authorize, :only => [:access_denied, :logout, :get_env]   #don't need the authorize filter for these actions

  def index
    #users home page. Here they are shown options of where they can go next.
    #post: the current term and the user
  	@current_term = current_term({exact: false, plan_b: :forward})
    @user = current_user
  end

  def access_denied
    redirect_to "/access_denied.html"
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
    # this action isn't permitted in production
    if ["development", "test"].include? Rails.env

      user = current_user
      new_role = Role.find params[:view_as].to_i
      user.Roles_idRoles = new_role.id
      session[:role] = new_role.RoleName

      user.save!
      redirect_to root_path
    else
      # not in development
      redirect_to "/access_denied"
    end

  end

  def get_env
		@env = request.env
  end

end
