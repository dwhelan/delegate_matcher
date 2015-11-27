module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToMethod < DelegateTo
        def do_delegate(test_delegate = delegate_double)
          delegator.ensure_valid_delegate_method(delegate)
          allow(delegator.sender).to receive(delegate) { test_delegate }
          call
        end
      end
    end
  end
end
