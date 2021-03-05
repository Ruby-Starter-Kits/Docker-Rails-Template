source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby "3.0.0"

gem "barnes", "~> 0.0.8"
gem "bootsnap", ">= 1.4.4", require: false
gem "image_processing", "~> 1.12"
gem "lograge", "~> 0.11.2"
gem "pg", "~> 1.1"
gem "premailer-rails", "~> 1.11"
gem "puma", "~> 5.0"
gem "rails", "~> 6.1.3"
gem "redis", "~> 4.2"
gem "sass-rails", ">= 6"
gem "sentry-raven", "~> 3.1"
gem "sidekiq", "~> 6.1"
gem "sidekiq-cron", "~> 1.2"
gem "turbolinks", "~> 5"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "webpacker", "~> 5.0"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "dotenv-rails", "~> 2.7"
  gem "factory_bot_rails"
  gem "rspec-rails", "~> 4.0"
end

group :development do
  gem "letter_opener", "~> 1.7"
  gem "letter_opener_web", "~> 1.4"
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "standardrb", "~> 1.0", require: false
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver"
  gem "webdrivers"
end
