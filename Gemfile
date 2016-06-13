source 'https://rubygems.org'

gem 'barge'
gem 'tugboat'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_GEM_VERSION'] || '~> 4.2.0'
  gem 'puppetlabs_spec_helper'
  gem 'rspec-puppet'
  gem 'webmock'
  gem 'metadata-json-lint'
  gem 'rubocop', '0.40.0', require: false
  gem 'simplecov'
  gem 'simplecov-console'
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  gem 'puppet-blacksmith'
  gem 'guard-rake'
  gem 'pry'
end
