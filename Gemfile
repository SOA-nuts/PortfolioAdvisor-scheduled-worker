# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# APPLICATION LAYER
# Web application related
gem 'roda', '~> 3.49'

# Configuration
gem 'figaro', '~> 1.2'

# Messaging
gem 'aws-sdk-sqs', '~> 1.48'

# Representers
gem 'multi_json'
gem 'roar'

# Controllers and services
gem 'dry-monads', '~> 1.4'
gem 'dry-transaction', '~> 0.13'
gem 'dry-validation', '~> 1.7'

# INFRASTRUCTURE LAYER
# Networking
gem 'http', '~> 5.0'

# DOMAIN LAYER
# Validation
gem 'dry-struct', '~> 1.4'
gem 'dry-types', '~> 1.5'

# Database
gem 'hirb', '~> 0'
gem 'hirb-unicode', '~> 0'
gem 'sequel', '~> 5.49'

# Asynchronicity
gem 'concurrent-ruby', '~> 1.1'

group :development, :test do
  gem 'sqlite3', '~> 1.4'
end

group :production do
  gem 'pg', '~> 1.2'
end
group :development do
  gem 'rerun', '~> 0'
end

# Debugging
gem 'pry'

# Web Scraper
gem 'nokogiri'

# text mining
gem 'textmood'
