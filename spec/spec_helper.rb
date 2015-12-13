require 'rspec'
require 'rspec/its'
require 'simplecov'
require 'coveralls'

require RUBY_VERSION =~ /2/ ? 'pry-byebug' : 'pry-debugger'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
]
SimpleCov.start

Coveralls.wear! if Coveralls.will_run?

require 'delegate_matcher'

Dir[File.dirname(__FILE__) + '/lib/shared/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.color = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
