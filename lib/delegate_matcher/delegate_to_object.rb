module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToObject < Delegate
        def do_delegate(_test_delegate = delegate_double)
          ensure_allow_nil_is_not_specified_for('an object')
          stub_delegation(delegate)
          call
        end

        def delegator_method
          @delegator_method || (prefix ? :"#{prefix}_#{method}" : method)
        end
      end
    end
  end
end
