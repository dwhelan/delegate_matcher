module RSpec
  module Matchers
    module DelegateMatcher
      class Expected
        attr_accessor :delegator
        attr_accessor :method
        attr_accessor :delegate
        attr_accessor :delegate_method
        attr_accessor :nil_check
        attr_accessor :prefix
        attr_accessor :args
        attr_accessor :block

        def delegate_method
          @via || @delegate_method || @method
        end

        def prefix=(prefix)
          @prefix = prefix || delegate.to_s.sub(/@/, '')
        end
      end
    end
  end
end
