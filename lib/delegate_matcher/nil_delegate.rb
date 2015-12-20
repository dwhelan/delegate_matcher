module RSpec
  module Matchers
    module DelegateMatcher
      class NilDelegate < Delegate
        def initialize(expected, to, &block)
          super
          original_receiver = receiver
          self.receiver = nil
          block.call
        ensure
          self.receiver = original_receiver
        end

        private

        # rubocop:disable Metrics/AbcSize
        def receiver=(value)
          case
          when a_class_variable?
            subject.class.class_variable_set(name, value)
          when an_instance_variable?
            subject.instance_variable_set(name, value)
          when a_constant?
            silence_warnings { subject.class.const_set(name, value) }
          when a_method?
            allow(subject).to receive(name) { value }
          else # an object
            fail 'cannot verify "allow_nil" expectations when delegating to an object' if value.nil?
          end
        end

        def silence_warnings(&block)
          warn_level = $VERBOSE
          $VERBOSE = nil
          block.call
        ensure
          $VERBOSE = warn_level
        end
      end
    end
  end
end
