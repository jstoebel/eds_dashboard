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
    # # puts session
    # puts "*"*50
    # puts user.is? "admin"
    # puts "*"*50
    #
    # if !(user.is? "admin")
    #   raise "access denied"
    # end
    user = User.find_by :UserName => session[:user]
    redirect_to "/access_denied" unless user.is? "admin"
  end
  # config.current_user_method(&:current_user)
  #
  # config.authorize_with :cancancan #TODO add cancancan to rails_admin config
  # config.current_user_method { current_user }

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
