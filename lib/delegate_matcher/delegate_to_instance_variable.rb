module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToInstanceVariable < DelegateTo
        def do_delegate(test_delegate = delegate_double)
          actual_delegate = delegator.instance_variable_get(delegate)
          delegator.instance_variable_set(delegate, test_delegate)
          call
        ensure
          delegator.instance_variable_set(delegate, actual_delegate)
        end
      end
    end
  end
end
