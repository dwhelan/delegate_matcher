module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToMethod < DelegateTo
        def do_delegate(test_delegate = delegate_double)
          ensure_delegate_method_is_valid
          allow(delegator).to receive(delegate) { test_delegate }
          call
        end

        def ensure_delegate_method_is_valid
          fail "#{delegator} does not respond to #{delegate}" unless delegator.respond_to?(delegate, true)
          fail "#{delegator}'s' #{delegate} method expects parameters" unless [0, -1].include?(delegator.method(delegate).arity)
        end
      end
    end
  end
end
