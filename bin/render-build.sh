#!/usr/bin/env bash

# Exit on error
set -o errexit

# apt-get install -y --no-install-recommends libjemalloc2

bundle install
yarn install 

bin/rails assets:precompile
bin/rails assets:clean

# If you have a paid instance type, we recommend moving
# database migrations like this one from the build command
# to the pre-deploy command:
bin/rails db:prepare
bin/rails db:seed