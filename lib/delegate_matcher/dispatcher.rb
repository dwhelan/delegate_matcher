module RSpec
  module Matchers
    module DelegateMatcher
      class Dispatcher
        attr_accessor :subject
        attr_reader :return_value, :expected

        def initialize(expected)
          self.expected = expected
        end

        def call
          self.return_value = subject.send(method_name, *expected.args, &block)
        end

        def method_name
          "#{expected.prefix}#{expected.method_name}"
        end

        def block
          @block ||= proc {}
        end

        def description
          "#{method_name}#{expected.argument_description}"
        end

        private

        attr_writer :expected, :return_value
      end
    end
  end
end
