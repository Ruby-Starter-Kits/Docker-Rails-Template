# By default Rails will keep writing to logs/development.log, this can lead to really large files.
# Let's configure this to be at most 50mb.
if Rails.env.development?
  Rails.logger = ActiveSupport::Logger.new(Rails.application.config.paths["log"].first, 1, 50.megabytes)
end
