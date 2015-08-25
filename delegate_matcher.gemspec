# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'delegate_matcher/version'

Gem::Specification.new do |gem|
  gem.name          = 'delegate_matcher'
  gem.version       = DelegateMatcher::VERSION
  gem.authors       = ['Declan Whelan']
  gem.email         = ['declan@pleanintuit.com']
  gem.summary       = 'A matcher for validating ruby delegation'
  gem.description   = 'A matcher for validating ruby delegation'
  gem.homepage      = 'https://github.com/dwhelan/delegate_matcher'
  gem.license       = 'MIT'

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler',   '~> 1.7'
  gem.add_development_dependency 'coveralls', '~> 0.7'
  gem.add_development_dependency 'rspec',     '~> 3.0'
  gem.add_development_dependency 'rspec-its', '~> 1.1'
  gem.add_development_dependency 'rubocop',   '~> 0.30'
  gem.add_development_dependency 'simplecov', '~> 0.9'
end
