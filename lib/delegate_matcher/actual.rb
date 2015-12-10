module RSpec
  module Matchers
    module DelegateMatcher
      class Actual
        RSpec::Mocks::Syntax.enable_expect(self)

        attr_reader :received, :args, :block
        alias_method :received?, :received

        def stub_receive(receiver, method_name)
          self.received = false
          allow(receiver).to receive(method_name) do |*args, &block|
            self.args     = args
            self.block    = block
            self.received = true
            return_value
          end
        end

        def argument_description
          args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
        end

        def return_value
          self
        end

        private

        attr_writer :received, :args, :block
      end
    end
  end
end
