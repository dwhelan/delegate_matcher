module RSpec
  module Matchers
    module DelegateMatcher
      class Dispatcher
        attr_reader :return_value

        def initialize(expected)
          self.expected = expected
        end

        def call
          args = expected.args
          args = [] if args && args[0].is_a?(Mocks::ArgumentMatchers::NoArgsMatcher)

          self.return_value = expected.subject.send(expected.delegator_method_name, *args, &block)
        end

        def block
          @block ||= expected.block.is_a?(Proc) ? expected.block : proc {}
        end

        private

        attr_accessor :expected
        attr_writer :return_value
      end
    end
  end
end
