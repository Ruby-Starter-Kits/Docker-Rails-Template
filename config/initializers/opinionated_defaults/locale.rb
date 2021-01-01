# Let break our locales into different files nested into subfiles

Rails.application.configure do
  config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}")]
  config.i18n.fallbacks = true
  # config.i18n.available_locales = [:en, :'en-GB', :de]

  ## If you're using the rack-contrib gem - You can use this middleware to auto set the locale.
  # config.middleware.use Rack::Locale
end
