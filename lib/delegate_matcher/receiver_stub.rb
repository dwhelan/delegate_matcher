module RSpec
  module Matchers
    module DelegateMatcher
      class ReceiverStub

        include RSpec::Mocks::ExampleMethods
        RSpec::Mocks::Syntax.enable_expect(self)

        attr_accessor :receiver
        attr_accessor :method_name
        attr_accessor :args
        attr_accessor :block
        attr_accessor :return_value
        attr_accessor :received

        def stub_receive(receiver, method_name)
          self.received = false
          allow(receiver).to receive(method_name) do |*args, &block|
            self.args     = args
            self.block    = block
            self.received = true
            return_value
          end
        end

        alias_method :received?, :received

        def argument_description
          args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
        end

        def return_value
          self
        end
      end
    end
  end
end
