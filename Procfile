# The Procfile is used by Heroku to define which services you'd like to run.
## Release tasks are used to automated running migrations on deploy.
release: ./bin/heroku/release-tasks.sh

## Web Instance, this'll serve TCP requests
web: ./bin/rails server -p ${PORT:-5000}

## Sidekiq is the de-facto standard choice for running Background tasks
# worker: ./bin/bundle exec sidekiq -C config/sidekiq.yml
