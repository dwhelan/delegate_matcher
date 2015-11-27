module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToClassVariable < DelegateTo
        def do_delegate(test_delegate = delegate_double)
          actual_delegate = delegator.class.class_variable_get(delegate)
          delegator.class.class_variable_set(delegate, test_delegate)
          call
        ensure
          delegator.class.class_variable_set(delegate, actual_delegate)
        end
      end
    end
  end
end
