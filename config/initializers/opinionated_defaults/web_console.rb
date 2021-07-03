# This adds the IP range for docker host, this allows us to use the web-console gem within docker.
Rails.application.configure do
  if Rails.env.development? && defined?(WebConsole)
    config.web_console.permissions = %w[172.0.0.0/10]

    # We have to reset the permissions like this as it's memorized within an initializer which is called
    # between the config/environments/development.rb file & this file.
    WebConsole::Request.permissions = WebConsole::Permissions.new(config.web_console.permissions)
  end
end
