module RSpec
  module Matchers
    module DelegateMatcher
      class StubDelegate < Delegate
        RSpec::Mocks::Syntax.enable_expect(self)

        attr_reader :return_value

        def initialize(expected, to)
          super
          stub_receiver
        end

        private

        attr_writer :return_value

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
