module RSpec
  module Matchers
    module DelegateMatcher
      class StubDelegate < Delegate
        RSpec::Mocks::Syntax.enable_expect(self)

        def initialize(expected)
          self.expected = expected
          self.received = false
          stub_receiver
        end

        private

        def stub_receiver
          allow(receiver).to receive(expected.as) do |*args, &block|
            self.args     = args
            self.block    = block
            self.received = true
            return_value
          end
        end
      end
    end
  end
end
