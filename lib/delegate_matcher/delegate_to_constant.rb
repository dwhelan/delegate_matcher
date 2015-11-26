module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToConstant < Delegate
        def do_delegate(_test_delegate = delegate_double)
          ensure_allow_nil_is_not_specified_for('a constant')
          stub_delegation(delegator.class.const_get(delegate))
          call
        end
      end
    end
  end
end