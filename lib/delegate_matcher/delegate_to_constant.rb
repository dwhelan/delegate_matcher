module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToConstant < DelegateTo
        def receiver
          dispatcher.sender.class.const_get(delegate)
        end
      end
    end
  end
end
