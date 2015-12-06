module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToMethod < DelegateTo
        def receiver
          delegator.ensure_valid_delegate_method(delegate)
          delegator.sender.send delegate
        end
      end
    end
  end
end
