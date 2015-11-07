guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^lib/(.+)\.rb$})        { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/spec_helper.rb$}) { 'spec' }
  watch(%r{^spec/shared/.+.rb$})   { 'spec' }
  watch(%r{^spec/.+_spec\.rb$})
end
