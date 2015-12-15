module RSpec
  module Matchers
    module DelegateMatcher
      class Delegate
        include Block

        RSpec::Mocks::Syntax.enable_expect(self)

        attr_reader :received, :args

        def initialize(expected)
          self.expected = expected
          self.received = false
        end

        # rubocop:disable Metrics/AbcSize
        def receiver
          @receiver ||= case
                        when a_class_variable?
                          subject.class.class_variable_get(name)
                        when an_instance_variable?
                          subject.instance_variable_get(name)
                        when a_constant?
                          subject.class.const_get(name)
                        when a_method?
                          fail "#{subject.inspect} does not respond to #{name}" unless subject.respond_to?(name, true)
                          fail "#{subject.inspect}'s' #{name} method expects parameters" unless [0, -1].include?(subject.method(name).arity)
                          subject.send(name)
                        else # is an object
                          to
                        end
        end

        def argument_description
          args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
        end

        def return_value
          self
        end

        private

        attr_accessor :expected
        attr_writer :received, :args, :block

        def subject
          expected.subject
        end

        def to
          expected.to
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
          a_reference?
        end

        def a_reference?
          to.is_a?(String) || to.is_a?(Symbol)
        end
      end
    end
  end
end
