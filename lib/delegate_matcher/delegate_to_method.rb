module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToMethod < DelegateTo
        def receiver
          Delegate.for(dispatcher.sender, expected.delegate, expected)
        end
      end
    end
  end
end
