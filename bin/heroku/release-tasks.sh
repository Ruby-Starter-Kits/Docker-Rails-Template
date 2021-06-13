#!/bin/bash

echo "Running Release Tasks"

# These run after a deploy has been build, but before it has been released.
if [ "$DURING_RELEASE_RUN_MIGRATIONS" == "enabled" ]; then
  echo "Running Migrations"
  bundle exec rake db:migrate || exit $?
fi

if [ "$DURING_RELEASE_SEED_DB" == "enabled" ]; then
  echo "Running Seeds"
  bundle exec rake db:seed || exit $?
fi

echo "Done"
