module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToInstanceVariable < DelegateTo
        def receiver
          dispatcher.sender.instance_variable_get(delegate)
        end
      end
    end
  end
end
