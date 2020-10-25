if defined?(Raven)
  Raven.configure do |config|
    config.async = ->(event) { SentryJob.perform_later(event) }
  end
end
