module RSpec
  module Matchers
    module DelegateMatcher
      class Expected
        attr_accessor :delegator
        attr_accessor :method
        attr_accessor :delegate
        attr_writer :delegate_method
        attr_accessor :nil_check
        attr_reader :prefix
        attr_accessor :delegator_args
        attr_accessor :delegate_args
        attr_accessor :block
        attr_accessor :skip_return_check

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
