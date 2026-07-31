#!/bin/bash
set -e

# Use Homebrew's Ruby (keg-only) instead of system Ruby 2.6.
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/4.0.0/bin:$PATH"

# The tuning apps live in henrylhale/tuning-playground, not here — see
# .github/workflows/deploy.yml. Stage them locally so previews match prod.
# Set TUNING_SRC to point at your checkout if it isn't the sibling directory.
TUNING_SRC="${TUNING_SRC:-$(cd "$(dirname "$0")/.." && pwd)/just-playground}"
if [ -d "$TUNING_SRC" ]; then
  mkdir -p tuning
  cp "$TUNING_SRC"/*.html tuning/ 2>/dev/null || true
  echo "Tuning apps staged from $TUNING_SRC ($(cd "$TUNING_SRC" && git rev-parse --short HEAD 2>/dev/null || echo 'unknown'))"
  echo "  pinned for production in .tuning-version: $(cut -c1-7 < .tuning-version)"
else
  echo "WARNING: $TUNING_SRC not found — /tuning/* will 404 in this preview."
fi

echo "Starting Jekyll local server..."
echo "Ruby: $(ruby -v)"
echo "Edit files and the browser will auto-reload at http://127.0.0.1:4000"

if ! command -v bundle >/dev/null 2>&1; then
  gem install --user-install bundler
fi

bundle config set --local path 'vendor/bundle'
bundle install
bundle exec jekyll serve --livereload
