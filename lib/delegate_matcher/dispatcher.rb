module RSpec
  module Matchers
    module DelegateMatcher
      class Dispatcher
        attr_accessor :subject
        attr_reader :return_value

        def initialize(expected)
          self.expected = expected
        end

        def call
          self.return_value = subject.send(expected.delegator_method_name, *expected.args, &block)
        end

        def block
          @block ||= proc {}
        end

        private

        attr_accessor :expected
        attr_writer :return_value
      end
    end
  end
end
