source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Rails gem
gem "rails", "~> 7.0.7", ">= 7.0.7.2"

# Asset pipeline and CSS handling
gem "sprockets-rails"          # For the asset pipeline (although you're using Tailwind via 'tailwindcss-rails')
gem "tailwindcss-rails", "~> 2.7" # For Tailwind CSS integration
gem "sassc-rails"             # Required for handling Sass (if you're using SCSS or Sass)

# Database
gem "sqlite3", "~> 1.4"

# Web server
gem "puma", "~> 5.0"

# Authentication with Devise
gem "devise", "~> 4.9"

# JavaScript and Front-end libraries
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "cable_ready", "~> 5.0"
gem "stimulus_reflex", "~> 3.5"

# Testing gems
gem "capybara"
gem "selenium-webdriver"
gem "webdrivers"

# Debugging and development tools
gem "web-console", group: :development
gem "annotate"
gem "debug", platforms: %i[ mri mingw x64_mingw ]
gem "byebug", "~> 11.1"

# For Redis (optional in your setup)
gem "redis-session-store", "~> 0.11.5"
gem "action-cable-redis-backport", "~> 1"

# For JSON APIs
gem "jbuilder"

# Miscellaneous
gem "view_component", "~> 3.14"
gem "bootsnap", require: false


gem "rails_event_store", "~> 2.15.0"
