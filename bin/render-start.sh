#!/usr/bin/env bash
set -o errexit

bundle exec rails db:prepare db:seed
exec bundle exec puma -C config/puma.rb
