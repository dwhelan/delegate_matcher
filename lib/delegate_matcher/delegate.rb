module RSpec
  module Matchers
    module DelegateMatcher
      class Delegate

        attr_accessor :receiver

        def initialize(expected)
          self.expected = expected
        end

        def receiver
          @receiver ||= case
                        when is_a_class_variable?
                          subject.class.class_variable_get(name)
                        when is_an_instance_variable?
                          subject.instance_variable_get(name)
                        when is_a_constant?
                          subject.class.const_get(name)
                        when is_a_method?
                          fail "#{subject.inspect} does not respond to #{name}" unless subject.respond_to?(name, true)
                          fail "#{subject.inspect}'s' #{name} method expects parameters" unless [0, -1].include?(subject.method(name).arity)
                          subject.send(name)
                        else
                          fail 'cannot verify "allow_nil" expectations when delegating to an object' unless expected.allow_nil.nil?
                          to
                        end
        end

        def prefix
          is_a_reference? ? name.delete('@') : ''
        end

        private

        attr_accessor :expected

        def is_a_reference?
          to.is_a?(String) || to.is_a?(Symbol)
        end

        def subject
          expected.subject
        end

        def to
          expected.to
        end

        def name
          to.to_s
        end

        def is_a_class_variable?
          name.start_with?('@@')
        end

        def is_an_instance_variable?
          name.start_with?('@')
        end

        def is_a_constant?
          is_a_reference? && name =~ /^[A-Z]/
        end

        def is_a_method?
          is_a_reference?
        end
      end
    end
  end
end
