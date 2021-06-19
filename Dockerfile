FROM ruby:3.0.1-alpine AS builder
LABEL maintainer="Mike Rogers <me@mikerogers.io>"

RUN apk --no-cache add --virtual build-dependencies \
      build-base \
      openssl \
      # Nokogiri Libraries
      zlib-dev \
      libxml2-dev \
      libxslt-dev \
      # Postgres
      postgresql-dev \
      # JavaScript
      nodejs \
      yarn \
      # FFI Bindings in ruby (Run C Commands)
      libffi-dev \
      # Fixes watch file issues with things like HMR
      libnotify-dev

# Dockerize allows us to wait for other containers to be ready before we run our own code.
ENV DOCKERIZE_VERSION v0.6.1
RUN wget -nv https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Rails Specific libraries
RUN apk --no-cache add \
      # ActiveStorage file inspection
      file \
      # Time zone data
      tzdata \
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
      # Allows for mimemagic gem to be installed
      shared-mime-info

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

# Add a script to be executed every time the container starts.
COPY bin/docker/entrypoints/* /usr/bin/
RUN chmod +x /usr/bin/wait-for-postgres.sh
RUN chmod +x /usr/bin/wait-for-web.sh
ENTRYPOINT ["/usr/bin/wait-for-postgres.sh"]

# Define the user running the container
USER appuser

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]

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
RUN yarn install --frozen-lockfile --check-files \
      && yarn cache clean --all

# Chown files so non are root.
COPY --chown=appuser:appgroup . /usr/src/app

# Precompile the assets, yarn relay & bootsnap
RUN RAILS_SERVE_STATIC_FILES=enabled \
      SECRET_KEY_BASE=secret-key-base \
      bundle exec rake assets:precompile \
      && bundle exec bootsnap precompile --gemfile app/ lib/
