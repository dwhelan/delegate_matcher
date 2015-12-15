module RSpec
  module Matchers
    module DelegateMatcher
      class Dispatcher
        attr_reader :return_value

        def initialize(expected)
          self.expected = expected
        end

        def call
          self.return_value = expected.subject.send(expected.delegator_method_name, *expected.args, &block)
        end

        def block
          @block ||= case expected.block
                   when nil? then
                     proc {}
                   when false then
                     proc {}
                   when true then
                     proc {}
                   else
                     expected.block
                   end
        end

        private

        attr_accessor :expected
        attr_writer :return_value
      end
    end
  end
end
