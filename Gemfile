source 'https://rubygems.org'

gem 'barge'
gem 'tugboat'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_VERSION'] || '~> 4.2.0'
  gem 'puppetlabs_spec_helper'
  gem 'rspec-puppet'
  gem 'webmock'
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  gem 'puppet-blacksmith'
  gem 'guard-rake'
  gem 'rubocop', require: false
  gem 'pry'
end
