FROM ruby:3.0.0-alpine AS builder
LABEL maintainer="Mike Rogers <me@mikerogers.io>"

RUN apk --no-cache add --virtual build-dependencies \
      build-base \
      # Nokogiri Libraries
      zlib-dev \
      libxml2-dev \
      libxslt-dev \
      # PG
      postgresql-dev \
      # JavaScript
      yarn \
      # FFI Bindings in ruby (Run C Commands)
      libffi-dev

RUN apk --no-cache add \
      # ActiveStorage file inspection
      file \
      # Time zone data
      tzdata \
      # JavaScript
      nodejs \
      # HTML to PDF conversion
      # ttf-ubuntu-font-family \
      # wkhtmltopdf \
      # Image Resizing
      imagemagick \
      vips \
      # Nice to have
      bash \
      git \
      # VIM is a handy editor for editing credentials
      vim \
      # Fixes watch file issues with things like HMR
      libnotify-dev

# Install any extra dependencies via Aptfile - These are installed on Heroku
# COPY Aptfile /usr/src/app/Aptfile
# RUN apk add --update $(cat /usr/src/app/Aptfile | xargs)

FROM builder AS development

# Set common ENVs
ENV BOOTSNAP_CACHE_DIR /usr/src/bootsnap
ENV YARN_CACHE_FOLDER /usr/src/yarn
ENV EDITOR vim
ENV LANG en_US.UTF-8
ENV BUNDLE_PATH /usr/local/bundle
ENV RAILS_LOG_TO_STDOUT enabled
ENV HISTFILE /usr/src/app/log/.bash_history

# Set build args. These let linux users not run into file permission problems
ARG USER_ID=${USER_ID:-1000}
ARG GROUP_ID=${GROUP_ID:-1000}

# Add non-root user and group with alpine first available uid, 1000
RUN addgroup -g $USER_ID -S appgroup \
      && adduser -u $GROUP_ID -S appuser -G appgroup

# Install multiple gems at the same time
RUN bundle config set jobs $(nproc)

# Create app directory in the conventional /usr/src/app
RUN mkdir -p /usr/src/app \
      && mkdir -p /usr/src/app/node_modules \
      && mkdir -p /usr/src/app/public/packs \
      && mkdir -p /usr/src/app/tmp/cache \
      && mkdir -p $YARN_CACHE_FOLDER \
      && mkdir -p $BOOTSNAP_CACHE_DIR \
      && chown -R appuser:appgroup /usr/src/app \
      && chown -R appuser:appgroup $BUNDLE_PATH \
      && chown -R appuser:appgroup $BOOTSNAP_CACHE_DIR \
      && chown -R appuser:appgroup $YARN_CACHE_FOLDER
WORKDIR /usr/src/app

ENV PATH /usr/src/app/bin:$PATH

# Define the user running the container
USER appuser

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

FROM development AS production

ENV RAILS_ENV production
ENV RACK_ENV production
ENV NODE_ENV production

COPY Gemfile /usr/src/app
COPY .ruby-version /usr/src/app
COPY Gemfile.lock /usr/src/app

# Install Ruby Gems
RUN bundle config set deployment 'true' \
      && bundle config set without 'development:test' \
      && bundle check || bundle install --jobs=$(nproc)

COPY package.json /usr/src/app
COPY yarn.lock /usr/src/app

# Install Yarn Libraries
RUN yarn install --check-files

# Chown files so non are root.
COPY --chown=appuser:appgroup . /usr/src/app

# Precompile the assets & bootsnap
RUN RAILS_SERVE_STATIC_FILES=enabled \
      SECRET_KEY_BASE=secret-key-base \
      bundle exec rake assets:precompile \
      && bundle exec bootsnap precompile --gemfile app/ lib/
