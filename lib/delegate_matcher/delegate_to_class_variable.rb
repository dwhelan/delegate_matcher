module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToClassVariable < DelegateTo
        def receiver
          delegator.sender.class.class_variable_get(delegate)
        end
      end
    end
  end
end
