require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new do |task|
  task.options << '--display-cop-names'
end

task default: [:spec, :rubocop, :build]
