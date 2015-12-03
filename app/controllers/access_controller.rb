class AccessController < ApplicationController
  require 'base64'

	layout 'application'

  def index
    #users home page. Here they are shown options of where they can go next.
  	@current_term = current_term({exact: false, plan_b: :forward})
  	# @request = request.authorization()
  	#@info = Base64.decode64(request)
 
  end

  def attempt_login
  	#if the user gets here they are authenticated as a Berea College user.
  	#next let's make sure they belong in this app

    @spam = request
    return

    user_pass = Base64.decode64(request.authorization.split(' ')[1])
    username = user_pass.split(':')[0]
    results = User.where(UserName: username)
    user = results.first

    return
    if user != nil
      #user is recognized in this site!
      session[:user] = user

      #TODO AUTHORIZATION determine students user is authorized to view in advisor pages.

      #redirect to their home page!
      if user.FirstName.present? and user.LastName.present?
        flash[:notice] = "Welcome, #{user.FirstName} #{user.LastName}!"
      else
        flash[:notice] = "Welcome, #{user.UserName}!"    
      end

      redirect_to access_index_path

    else  #user not allowed in this app!
      
      redirect_to access_access_denied_path("denied")
    end


  end

  def access_denied
  end

  def logout
    session[:user] = nil
    redirect_to "https://log:out@edsdata.berea.edu"
  end

 
end
