module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToObject < DelegateTo
        def do_delegate(test_delegate = delegate_double, &block)
          ensure_allow_nil_is_not_specified_for('an object')
          # Stubber.new.stub(delegate, expected.method, test_delegate, &block)
          receiver = expected.delegate
          stub_delegation receiver
          block.call
        end

        def default_prefix
          fail 'must use an explicit prefix when expecting delegating to an object with a prefix'
        end
      end
    end
  end
end
