module RSpec
  module Matchers
    module DelegateMatcher
      class NilDelegate < Delegate

        def initialize(expected, &block)
          super
          original_receiver = receiver
          set_receiver(nil)
          block.call
        ensure
          set_receiver(original_receiver)
        end

        private

        def set_receiver(value)
          case
          when is_a_class_variable?
            subject.class.class_variable_set(name, value)
          when is_an_instance_variable?
            subject.instance_variable_set(name, value)
          when is_a_constant?
            subject.class.const_set(name, value)
          when is_a_method?
            allow(subject).to receive(name) { value }
          else # is an object
            fail 'cannot verify "allow_nil" expectations when delegating to an object' unless expected.allow_nil.nil?
          end
        end
      end
    end
  end
end

