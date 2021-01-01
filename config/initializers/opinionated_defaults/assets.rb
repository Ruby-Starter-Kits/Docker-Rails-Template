Rails.application.configure do
  # Add some sensible caching headers all assets. Sometimes Nginx adds these, but not always.
  config.static_cache_control = "public, max-age=31536000"
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=31536000",
    "Expires" => 1.year.from_now.to_formatted_s(:rfc822)
  }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server (Normally https://cdn.yourdomain.com).
  if ENV["ASSET_HOST"]
    config.action_controller.asset_host = ENV["ASSET_HOST"]
    config.action_mailer.asset_host = ENV["ASSET_HOST"]
  elsif ENV["HEROKU_APP_NAME"].present?
    config.action_controller.asset_host = "https://#{ENV["HEROKU_APP_NAME"]}.herokuapp.com"
    config.action_mailer.asset_host = "https://#{ENV["HEROKU_APP_NAME"]}.herokuapp.com"
  end
end
