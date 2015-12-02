module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToConstant < DelegateTo
        def do_delegate(test_delegate = delegate_double)
          stub_const("#{delegator.sender.class}::#{delegate}", test_delegate)
          yield
        end
      end
    end
  end
end
