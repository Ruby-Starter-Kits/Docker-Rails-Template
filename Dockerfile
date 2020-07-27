FROM ruby:2.7.1-alpine AS builder

LABEL maintainer="Mike Rogers <me@mikerogers.io>"

RUN apk add --no-cache \
    #
    # required
    build-base libffi-dev \
    nodejs yarn tzdata \
    postgresql-dev zlib-dev libxml2-dev libxslt-dev readline-dev bash \
    # Nice to haves
    git vim \
    #
    # Fixes watch file issues with things like HMR
    libnotify-dev

FROM builder as development

# Add the current apps files into docker image
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install any extra dependencies via Aptfile - These are installed on Heroku
# COPY Aptfile /usr/src/app/Aptfile
# RUN apk add --update $(cat /usr/src/app/Aptfile | xargs)

ENV PATH /usr/src/app/bin:$PATH

# Install latest bundler
RUN bundle config --global silence_root_warning 1

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

FROM development AS production

# Install Ruby Gems
COPY Gemfile /usr/src/app
COPY Gemfile.lock /usr/src/app
RUN bundle check || bundle install --jobs=$(nproc)

# Install Yarn Libraries
COPY package.json /usr/src/app
COPY yarn.lock /usr/src/app
RUN yarn install --check-files

# Copy the rest of the app
COPY . /usr/src/app

# Compile the assets
RUN RAILS_SERVE_STATIC_FILES=enabled SECRET_KEY_BASE=secret-key-base RAILS_ENV=production RACK_ENV=production NODE_ENV=production bundle exec rake assets:precompile
