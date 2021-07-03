#!/bin/bash
set -e

# Wait for Postgres to start before doing anything
echo ""
echo "== ⏱  Waiting for Postgres before running: $@ =="
dockerize -wait tcp://postgres:5432 -timeout 60s -wait-retry-interval 5s

# Then exec the container's main process (what's set as CMD in the Dockerfile).
echo ""
echo "== 🏎  Running: $@ =="
exec "$@"
