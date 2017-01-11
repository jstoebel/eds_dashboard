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

  config.label_methods = [:repr]

  config.authorize_with do
    # not happy with this solution at the moment. I'd prefer not having to check the env.
    case Rails.env
    when "production"
      user_name = session[:user]
    when "development"
      user_name = session[:user]
    when "test"
      user_name = request.filtered_parameters["env"]["REMOTE_USER"]
    else
      raise "unknown enviornment: #{Rails.env}"
    end

    user = User.find_by :UserName => user_name
    redirect_to "/access_denied" if [!user.andand.is?("admin") || user.nil?].any?
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


  # config.model "Program" do
  #   object_label_method do
  #
  #   end
  # end

  config.model 'ProgExit' do
    export do
      field :student
      field :program
      field :exit_code
      field :banner_term
      field :ExitDate
      field :GPA
      field :GPA_last60
      field :RecommendDate
      field :Details
    end
  end
end
