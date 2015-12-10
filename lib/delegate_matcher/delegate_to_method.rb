module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToMethod < DelegateTo
        def receiver
          dispatcher.ensure_valid_delegate_method(expected.delegate)
          Delegate.for(dispatcher.sender, expected.delegate)
        end
      end
    end
  end
end
