module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToObject < DelegateTo
        def do_delegate(_test_delegate = delegate_double)
          ensure_allow_nil_is_not_specified_for('an object')
          stub_delegation(expected.delegate)
          yield
        end
      end
    end
  end
end
