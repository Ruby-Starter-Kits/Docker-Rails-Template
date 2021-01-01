# By default Rails can generate very verbose logs.
# I'm a fan of: https://github.com/roidrage/lograge
# It makes every request a single line in the logs.
if defined?(Lograge)
  Rails.application.configure do
    config.lograge.enabled = true
    config.lograge.custom_options = lambda do |event|
      # No params? Must be ActionCable.
      return {} if event.payload[:params].blank?

      exceptions = %w[controller action format authenticity_token]

      {
        params: event.payload[:params].except(*exceptions)
      }
    end

    config.lograge.custom_payload do |controller|
      {
        host: controller.request.host,
        remote_ip: controller.request.remote_ip,
        api_key: controller.request.headers.env["HTTP_X_APIKEY"]
      }
    end
  end
end
