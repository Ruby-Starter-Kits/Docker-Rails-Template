# Sidekiq is the de-facto standard choice for running Background tasks
# You should use it to perform API requests & long running tasks.
if defined?(Sidekiq) && ENV["REDIS_URL"].present?
  require "sidekiq/web"
  require "sidekiq/cron/web" if defined?(Sidekiq::Cron)

  # https://github.com/mperham/sidekiq/wiki/Monitoring#rails-http-basic-auth-from-routes
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username),
      ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password),
        ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
  end

  # https://github.com/ondrejbartas/sidekiq-cron
  # Sidekiq-cron - It's a very sensible approach to performing scheduled tasks.
  if Sidekiq.server? && defined?(Sidekiq::Cron)
    Rails.application.config.after_initialize do
      schedule_file = Rails.root.join("config/schedule.yml")
      schedule_file_yaml = YAML.load_file(schedule_file) if schedule_file.exist?

      # Use https://crontab.guru to confirm times
      Sidekiq::Cron::Job.load_from_hash(schedule_file_yaml) if schedule_file_yaml
    end
  end

  Sidekiq.configure_client do |_config|
    # Any client specific configuration
  end

  Rails.application.config.cache_store = :redis_cache_store, {
    url: ENV["REDIS_URL"],
    network_timeout: 5
  }
  Rails.application.config.active_job.queue_adapter = :sidekiq
else
  Rails.application.config.active_job.queue_adapter = :inline
end
