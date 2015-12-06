module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToClassVariable < DelegateTo
        def receiver
          dispatcher.sender.class.class_variable_get(delegate)
        end
      end
    end
  end
end
