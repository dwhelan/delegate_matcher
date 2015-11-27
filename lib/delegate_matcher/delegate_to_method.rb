module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToMethod < DelegateTo
        def do_delegate(test_delegate = delegate_double)
          ensure_delegate_method_is_valid
          allow(delegator.sender).to receive(delegate) { test_delegate }
          call
        end

        def ensure_delegate_method_is_valid
          fail "#{delegator.sender} does not respond to #{delegate}" unless delegator.sender.respond_to?(delegate, true)
          fail "#{delegator.sender}'s' #{delegate} method expects parameters" unless [0, -1].include?(delegator.sender.method(delegate).arity)
        end
      end
    end
  end
end
