#!/bin/bash
set -e

# Use Homebrew's Ruby (keg-only) instead of system Ruby 2.6.
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/4.0.0/bin:$PATH"

echo "Starting Jekyll local server..."
echo "Ruby: $(ruby -v)"
echo "Edit files and the browser will auto-reload at http://127.0.0.1:4000"

if ! command -v bundle >/dev/null 2>&1; then
  gem install --user-install bundler
fi

bundle config set --local path 'vendor/bundle'
bundle install
bundle exec jekyll serve --livereload
