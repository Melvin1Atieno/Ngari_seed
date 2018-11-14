require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NgariSeed
  class Application < Rails::Application

				config.time_zone = 'Nairobi'
				# App version from git commit message. Message must contain versioning major.minor.fix e.g 0.2.31
				config.version = {
					master: (`git --no-pager log master -1 --pretty=%B`.presence || `cd ../repo && git --no-pager log master -1 --pretty=%B`.presence rescue ''),
					develop: (`git --no-pager log develop -1 --pretty=%B`.presence || `cd ../repo && git --no-pager log develop -1 --pretty=%B`.presence rescue '')
				}
				config.version_no = {
					master: (config.version[:master].scan(/d+.d+.d+/).first rescue ''),
					develop: (config.version[:develop].scan(/d+.d+.d+/).first rescue '')
				}

				# ActionMailer Config
				config.action_mailer.default_url_options = { host: ENV['DOMAIN_NAME'] }
				config.action_mailer.perform_deliveries = true
				config.action_mailer.raise_delivery_errors = true
				config.action_mailer.asset_host = ['https://', ENV['DOMAIN_NAME']].join

				config.action_mailer.smtp_settings = {
					address: ENV['SMTP_ADDRESS'],
					port: 587,
					domain: ENV['DOMAIN_NAME'],
					authentication: "plain",
					enable_starttls_auto: true,
					user_name: ENV['SMTP_USERNAME'],
					password: ENV['SMTP_PASSWORD']
				}

    config.active_job.queue_adapter = :sidekiq
    # config.active_job.queue_name_prefix = Rails.env
    # config.active_job.queue_name_delimiter = '.'
    config.middleware.use Rack::Attack
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
