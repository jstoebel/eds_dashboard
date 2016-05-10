class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  require 'socket'
  include ApplicationHelper

  before_filter :authorize
  protect_from_forgery with: :exception

  def current_user
    puts "STARTING current_user"
    puts "****"
    puts session[:user]
    puts "****"
    user = User.find_by(:UserName => session[:user])

    user.view_as = session[:view_as]
    return user
  end

  def user_bnum
    user = current_user
    bnum = user.tep_advisor.AdvisorBnum
  end

  # Catch all CanCan errors and alert the user of the exception
  rescue_from CanCan::AccessDenied do | exception |
    flash[:notice] = exception.message
    redirect_to "/access_denied"
  end

  def authorize
    #if the user gets here they are authenticated as a Berea College user.

    #get the ip address as a second way to verify we are on the production server
    ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}

    if Rails.env.production? or ip.ip_address == "10.40.42.92"
      #login if we are in production
      unless session[:user].present?    #look up username and role if we don't have it.

        username = request.env["AUTHORIZE_SAMACCOUNTNAME"]
        results = User.where(UserName: username)
        user = results.first
        if user != nil
          session[:user] = user.UserName
          session[:role] = user.role_name
          if session[:user] == "admin"
            session[:view_as] = 1   # default to view as admin
          end
          #user is recognized in this site!

          #redirect to their home page!
          if user.FirstName.present? and user.LastName.present?
            flash[:notice] = "Welcome, #{user.FirstName} #{user.LastName}!"
          else
            flash[:notice] = "Welcome, #{user.UserName}!"    
          end

          #done!
          
        else  #couldn't find user in database ->authorize failed!
          redirect_to "/access_denied"
        end

      end

    else # we're in development
      #always login as a special account: dev_admin

      admin_user = User.find_by({UserName: "dev_admin"})
      session[:user] = admin_user.UserName
      session[:role] = admin_user.role_name

    end

  end

  private
  	def find_student(alt_id)
  		return Student.where(AltID: alt_id).first
  		
  	end

  	def find_praxis_result(alt_stuid)
  		return PraxisResult.where(AltID: alt_stuid).first
  		
  	end

  	def find_issue(alt_stuid)
  		return Issue.where(AltID: alt_stuid).first
  	end

  def term_menu_setup
    #pre: nothing
    #post:
      #menu_terms: all of the terms to be include in the term menu
     @current_term = current_term(exact: false, plan_b: :back)

    if params[:banner_term_id]
      @term = BannerTerm.find(params[:banner_term_id])   #ex: 201412
    else
      @term = @current_term   #if no params passed, the term to render is current term
    end

    #assemble possible terms for select menu: all terms less than more than 
    #2 years ago, no future terms.

    @menu_terms = BannerTerm.where("StartDate > ? and StartDate < ?", Date.today-730, Date.today)

    if (@current_term) and not (@menu_terms.include? @current_term)
      @menu_terms << @current_term    #add the current term if its not there already.
    end
   end

   def to_console(object)
    puts "*"*100
    puts object
    puts "*"*100
   end

end
