# Sets the default URL options to the URL env.
if ENV["URL"].present?
  Rails.application.default_url_options = {
    host: ENV["URL"],
    protocol: "https"
  }
elsif ENV["HEROKU_APP_NAME"].present?
  Rails.application.default_url_options = {
    protocol: "https",
    host: "#{ENV["HEROKU_APP_NAME"]}.herokuapp.com"
  }
end
