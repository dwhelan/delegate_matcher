module RSpec
  module Matchers
    module DelegateMatcher
      class Dispatcher
        attr_accessor :subject
        attr_reader :return_value, :expected

        def initialize(subject, expected)
          self.subject  = subject
          self.expected = expected
        end

        def call
          self.return_value = subject.send(method_name, *expected.as_args, &block)
        end

        def method_name
          "#{expected.prefix}#{expected.method_name}"
        end

        def block
          @block ||= proc {}
        end

        def description
          "#{method_name}#{argument_description}"
        end

        def argument_description
          args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
        end

        private

        attr_writer :subject, :expected, :return_value
      end
    end
  end
end
