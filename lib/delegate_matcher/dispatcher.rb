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
          self.return_value = subject.send(expected.delegator_method_name, *expected.args, &block)
        end

        def block
          @block ||= proc {}
        end

        def description
          "#{expected.delegator_method_name}#{expected.argument_description}"
        end

        private

        attr_writer :expected, :return_value
      end
    end
  end
end
