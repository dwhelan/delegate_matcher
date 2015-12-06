module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToClassVariable < DelegateTo
        def do_delegate(test_delegate = delegate_double, &block)
          receiver = Stubber.new.stub(delegator.sender, delegate, test_delegate, &block)
          stub_delegation receiver
          block.call
        end
      end
    end
  end
end
