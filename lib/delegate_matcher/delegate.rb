module RSpec
  module Matchers
    module DelegateMatcher
      class Delegate
        include Block

        RSpec::Mocks::Syntax.enable_expect(self)

        attr_reader :to, :received, :args

        def initialize(expected, to)
          self.expected = expected
          self.to       = to
          self.received = false
        end

        # rubocop:disable Metrics/AbcSize
        def receiver
          klass = subject.class
          @receiver ||= case
                        when a_class_variable?
                          klass.class_variable_get(name)
                        when an_instance_variable?
                          subject.instance_variable_get(name)
                        when a_constant?
                          klass.const_get(name)
                        when a_method?
                          subject.send(name)
                        when a_reference?
                          subject.instance_eval(name)
                        else # is an object
                          to
                        end
        end

        def argument_description
          args ? "(#{args.map(&:inspect).join(', ')})" : ''
        end

        private

        attr_accessor :expected
        attr_writer :to, :received, :args, :block

        def subject
          expected.subject
        end

        def name
          to.to_s
        end

        def a_class_variable?
          a_reference? && name.start_with?('@@')
        end

        def an_instance_variable?
          a_reference? && name.start_with?('@')
        end

        def a_constant?
          a_reference? && name =~ /^[A-Z]/
        end

        def a_method?
          a_reference? && subject.respond_to?(name, true)
        end

        def a_reference?
          to.is_a?(String) || to.is_a?(Symbol)
        end
      end
    end
  end
end
