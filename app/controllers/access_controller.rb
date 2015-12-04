class AccessController < ApplicationController
	layout 'application'

  def index
    #users home page. Here they are shown options of where they can go next.
  	@current_term = current_term({exact: false, plan_b: :forward})
    
 
  end

  def attempt_login
  	#if the user gets here they are authenticated as a Berea College user.
  	#next let's make sure they belong in this app

    username = request.env["AUTHORIZE_SAMACCOUNTNAME"]
    results = User.where(UserName: username)
    user = results.first
    if user != nil
      session[:user] = user.UserName
      session[:role] = user.role_name
      #user is recognized in this site!
      
      #TODO AUTHORIZATION determine students user is authorized to view in advisor pages.

      #redirect to their home page!
      if user.FirstName.present? and user.LastName.present?
        flash[:notice] = "Welcome, #{user.FirstName} #{user.LastName}!"
      else
        flash[:notice] = "Welcome, #{user.UserName}!"    
      end

      redirect_to access_index_path

    else  #user not allowed in this app!
      redirect_to "/access_denied"
    end


  end

  def access_denied
  end

  def logout
    session[:user] = nil
    session[:role] = nil
    redirect_to "https://log:out@edsdata.berea.edu"
  end

 
end
