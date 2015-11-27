module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToClassVariable < DelegateTo
        def do_delegate(test_delegate = delegate_double)
          actual_delegate = delegator.sender.class.class_variable_get(delegate)
          delegator.sender.class.class_variable_set(delegate, test_delegate)
          yield
        ensure
          delegator.sender.class.class_variable_set(delegate, actual_delegate)
        end
      end
    end
  end
end
