require_relative 'boot'
require 'rails/all'
require 'csv'

# assume a capistrano deployment with current deployment sitting in ~/eds_dashboard/current
secrets_file = File.join(File.dirname(__FILE__), '../../../..', '.eds_secrets.yml')
SECRET = File.exists?(secrets_file) ? YAML.load_file(secrets_file) : {}

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Eds
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    # SMTP settings for mailgun
    ActionMailer::Base.smtp_settings = {
      :port           => 587,
      :address        => "smtp.office365.com",
      :domain         => SECRET['APP_EMAIL_DOMAIN'],
      :user_name      => SECRET['APP_EMAIL_USERNAME'],
      :password       => SECRET['APP_EMAIL_PASSWORD'],
      :authentication => :login,
      :enable_starttls_auto => true
    }

    Rails.application.config.active_job.queue_adapter = :delayed_job

  end
end
