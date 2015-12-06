module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToMethod < DelegateTo
        def do_delegate(test_delegate = delegate_double, &block)
          delegator.ensure_valid_delegate_method(delegate)
          receiver = Stubber.new.stub(delegator.sender, delegate, test_delegate, &block)
          stub_delegation receiver
          block.call
          # Stubber.new.stub(delegator.sender, delegate, test_delegate, &block)
          # delegator.ensure_valid_delegate_method(delegate)
          # allow(delegator.sender).to receive(delegate) { test_delegate }
          # yield
        end
      end
    end
  end
end
