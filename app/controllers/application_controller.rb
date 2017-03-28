require 'socket'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  include ApplicationHelper

  before_filter :authorize
  protect_from_forgery with: :exception

  def current_user
    # user = User.find_by(:UserName => session[:user])
    # user.view_as = session[:view_as]
    # return user
    return User.find_by(:UserName => session[:user]) if session[:user]
  end
  helper_method :current_user

  def user_bnum
    user = current_user
    bnum = user.tep_advisor.AdvisorBnum
  end

  # Catch all CanCan errors and alert the user of the exception
  rescue_from CanCan::AccessDenied do | exception |
    redirect_to "/access_denied"
  end

  def authorize
    #if the user gets here they are authenticated as a Berea College user.

    #get the ip address as a second way to verify we are on the production server
    ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}

    if Rails.env.production? or ip.ip_address == "10.40.42.106"
      #login if we are in production
      unless session[:user].present?    #look up username and role if we don't have it.

        username = request.env["REMOTE_USER"]  #will be standard berea email ex feej@berea.edu
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
      #log us in as dev_admin if there is no session info
      unless session[:user]
        user_params = {
          UserName: "dev_admin",
          FirstName: "Dev",
          LastName: "Admin",
          Email: "devadmin@test.com"
        }
        admin_user = User.find_by(user_params)
        
        if admin_user.blank?
          admin_user = User.create!(user_params.merge({:Roles_idRoles => 1}))
        end

        session[:user] = admin_user.UserName
        session[:role] = admin_user.role_name

      end
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

  def term_menu_setup(table_name, term_col)
    #prepares all terms where records are found for the given model
    #table_name (symbol)
    #term_col (symbol) the name of the column in this table where the banner_term fk is stored
    #post: current_term and menu_terms are set

    #TODO refactoring all tables that reference banner_terms to have fk col name be simply banner_term_id will
      #allow us to remove the param term_col

    @current_term = BannerTerm.current_term(exact: false, plan_b: :back)

    if params[:banner_term_id]
      @term = BannerTerm.find(params[:banner_term_id])   #ex: 201412
    else
      @term = @current_term   #if no params passed, the term to render is current term
    end
    @menu_terms = BannerTerm.all.joins(table_name).group(term_col)

  end

   def to_console(object)
    puts "*"*100
    puts object
    puts "*"*100
   end

end
