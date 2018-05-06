source 'https://rubygems.org'
ruby '2.4.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'bootstrap-sass', '~> 3.3'
gem 'clockwork'
gem 'coffee-rails', '~> 4.1.0'
gem 'dotenv-rails', :groups => [:development, :test]
gem 'facebook-messenger', '~> 0.8.0'
gem 'faraday'
gem 'foreman', '~> 0.78.0', require: false
gem 'jquery-rails', '~> 4.1'
gem 'rails'
gem 'pg',                               '0.18.4'
gem 'sass-rails',                       '~> 5.0'
gem 'turbolinks'
gem "uglifier",                         ">= 1.3.0"
gem "puma",                             "3.10"
gem "omniauth-google-oauth2",           "0.4.1"
gem "redis",                            "3.3.0"
gem "sidekiq",                          "4.1.1"
gem "will_paginate"


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'codacy-coverage', require: false
  gem 'coveralls', require: false
  gem 'factory_bot_rails'
  gem 'ffaker'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'sqlite3'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'climate_control'
end
