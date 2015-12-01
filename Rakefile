require 'rubygems'
require 'bundler/setup'

require 'puppetlabs_spec_helper/rake_tasks'
require 'rubocop/rake_task'

begin
  require 'puppet_blacksmith/rake_tasks'
rescue LoadError # rubocop:disable Lint/HandleExceptions
end


RuboCop::RakeTask.new

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

Rake::Task[:lint].clear

PuppetLint.configuration.relative = true
PuppetLint.configuration.disable_80chars
PuppetLint.configuration.disable_class_inherits_from_params_class
PuppetLint.configuration.fail_on_warnings = true
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
end

PuppetSyntax.exclude_paths = exclude_paths

desc "Run syntax, lint, and spec tests."
task :test => [
  :metadata,
  :syntax,
  :lint,
  :rubocop,
  :spec,
]
