RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar true

  config.authorize_with do
    # not happy with this solution at the moment. I'd prefer not having to check the env.
    if ["prodution", "development"].include? Rails.env
      user_name = session[:username]
    elsif Rails.env == "test"
      user_name = request.filtered_parameters["env"]["REMOTE_USER"]
    else
      raise "unknown enviornment: #{Rails.env}"
    end
    user = User.find_by :UserName => user_name
    redirect_to "/access_denied" unless user.is? "admin"
  end

  config.excluded_models = ["Access", "Report"]

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
