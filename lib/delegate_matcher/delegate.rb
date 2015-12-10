module RSpec
  module Matchers
    module DelegateMatcher
      class Delegate

        attr_accessor :delegate, :prefix

        def initialize(sender, to, options)
          if to.is_a?(String) || to.is_a?(Symbol)
            name = to.to_s

            self.delegate = case
            when name.start_with?('@@')
              sender.class.class_variable_get(name)
            when name.start_with?('@')
              sender.instance_variable_get(name)
            when name =~ /^[A-Z]/
              sender.class.const_get(name)
            else # a method
              fail "#{sender.inspect} does not respond to #{name}" unless sender.respond_to?(name, true)
              fail "#{sender.inspect}'s' #{name} method expects parameters" unless [0, -1].include?(sender.method(name).arity)
              sender.send(name)
            end

            self.prefix = name.delete('@')
          else
            fail 'cannot verify "allow_nil" expectations when delegating to an object' unless options.allow_nil.nil?
            self.delegate = to
            self.prefix   = ''
          end
        end
      end
    end
  end
end
