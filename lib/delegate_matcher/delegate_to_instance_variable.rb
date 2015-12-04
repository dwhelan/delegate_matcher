module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToInstanceVariable < DelegateTo
        def do_delegate(test_delegate = delegate_double, &block)
          Stubber.stub(delegator.sender, delegate, test_delegate, &block)
        end
      end
    end
  end
end
