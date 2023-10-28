# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.3', '>= 7.0.3.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~> 6.0.0'
  gem 'byebug', '~> 11.1'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'rubocop', '~> 1.41'
  gem 'rubocop-rails', '~> 2.17'
  gem 'web-console'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'inertia_rails', '~> 2.0'

gem 'vite_rails', '~> 3.0'

gem 'mongoid', '~> 8.0'

gem "aws-sdk-s3", "~> 1.118"

gem "dotenv-rails", "~> 2.8", :groups => [:development, :test]

gem "factory_bot", "~> 6.2"

gem "faker", "~> 3.2"

gem "rails_admin", "~> 3.1"
gem "sassc-rails"

gem "kaminari-mongoid", "~> 1.0"

gem "rails_admin-i18n"

gem "rails-i18n", "~> 7.0"

gem "devise", "~> 4.9"

gem "tailwindcss-rails", "~> 2.0"
