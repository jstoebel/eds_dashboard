class AccessController < ApplicationController
  require 'base64'

	layout 'application'

  def index
  	@current_term = current_term({exact: false, plan_b: :forward})
  	user_pass = Base64.decode64(request.authorization.split(' ')[1])
	@username = user_pass.split(':')[0]


  end

  def login
  end
end
