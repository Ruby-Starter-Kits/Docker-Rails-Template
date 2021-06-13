#!/bin/bash
set -e

# Wait for Web to start before doing anything
echo ""
echo "== ⏱  Waiting for Postgres & Web to start before running: $@ =="
dockerize -wait tcp://postgres:5432
dockerize -wait tcp://web:3000

# Then exec the container's main process (what's set as CMD in the Dockerfile).
echo ""
echo "== 🏎  Running: $@ =="
exec "$@"
