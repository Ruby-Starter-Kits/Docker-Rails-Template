source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'rspec-rails', '~> 4.0', :groups => %i[development test]

gem 'redis', '~> 4.2'

gem 'image_processing', '~> 1.12'

gem 'dotenv-rails', '~> 2.7', :groups => %i[development test]

gem 'rubocop', '~> 1.1', :group => :development

gem 'rubocop-rails', '~> 2.8', :group => :development

gem 'letter_opener', '~> 1.7', :group => :development

gem 'letter_opener_web', '~> 1.4', :group => :development

gem 'lograge', '~> 0.11.2'

gem 'sentry-raven', '~> 3.1'

gem 'barnes', '~> 0.0.8'

gem 'sidekiq', '~> 6.1'

gem 'sidekiq-cron', '~> 1.2'
