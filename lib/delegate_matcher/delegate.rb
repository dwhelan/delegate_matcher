module RSpec
  module Matchers
    module DelegateMatcher
      class Delegate

        attr_accessor :delegate, :prefix

        def initialize(subject, to, expected)
          if to.is_a?(String) || to.is_a?(Symbol)
            name = to.to_s

            self.delegate = case
            when name.start_with?('@@')
              subject.class.class_variable_get(name)
            when name.start_with?('@')
              subject.instance_variable_get(name)
            when name =~ /^[A-Z]/
              subject.class.const_get(name)
            else # a method
              fail "#{subject.inspect} does not respond to #{name}" unless subject.respond_to?(name, true)
              fail "#{subject.inspect}'s' #{name} method expects parameters" unless [0, -1].include?(subject.method(name).arity)
              subject.send(name)
            end

            self.prefix = name.delete('@')
          else
            fail 'cannot verify "allow_nil" expectations when delegating to an object' unless expected.allow_nil.nil?
            self.delegate = to
            self.prefix   = ''
          end
        end
      end
    end
  end
end
