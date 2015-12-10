module RSpec
  module Matchers
    module DelegateMatcher
      class Delegate
        class << self
          def for(sender, name_or_object, options)
            if name_or_object.is_a?(String) || name_or_object.is_a?(Symbol)
              name = name_or_object.to_s

              case
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
            else
              fail 'cannot verify "allow_nil" expectations when delegating to an object' unless options.nil_check.nil?
              name_or_object
            end
          end
        end
      end
    end
  end
end
