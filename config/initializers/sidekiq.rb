Sidekiq.configure_server do |config|
  config.redis = { namespace: "ngari_seed_#{Rails.env}" }

  # sidekiq-failures
  config.failures_max_count = 5000 # false # to disable limit
  # config.failures_default_mode = :all # :exhausted :off 
  # config.server_middleware do |chain|
  #   chain.add Sidekiq::Middleware::Server::RetryJobs, :max_retries => 5
  # end
  # config.client_middleware do |chain|
  #   chain.add Sidekiq::Middleware::Server::RetryJobs, :max_retries => 5
  # end
  
  # https://github.com/gevans/sidekiq-throttler
  # config.server_middleware do |chain|
  #   chain.add Sidekiq::Throttler, storage: :redis, threshold: 50, period: 1.hour
  # end

  # schedule_file = "config/schedule.yml"
  # if File.exists?(schedule_file)
  #   Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file)
  # end
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: "ngari_seed_#{Rails.env}" }
  # config.client_middleware do |chain|
  #   chain.add Sidekiq::Middleware::Client::RetryJobs, :max_retries => 5
  # end
end

# Sidekiq::Cron::Job.destroy_all!
schedule_file = "config/schedule.yml"
if File.exists?(schedule_file)
  Sidekiq::Cron::Job.load_from_hash! YAML.load_file(schedule_file) rescue puts 'Redis is not on. No Cron jobs started'
end

Sidekiq.default_worker_options = {
  unique: :until_executing,
  unique_args: ->(args) { args.first.except('job_id') }
}
