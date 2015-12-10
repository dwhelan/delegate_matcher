module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToClassVariable < DelegateTo
        def receiver
          Delegate.for(dispatcher.sender, expected.delegate, expected)
        end
      end
    end
  end
end
