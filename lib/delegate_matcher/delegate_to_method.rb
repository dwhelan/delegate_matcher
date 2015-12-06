module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToMethod < DelegateTo
        def receiver
          dispatcher.ensure_valid_delegate_method(delegate)
          dispatcher.sender.send delegate
        end
      end
    end
  end
end
