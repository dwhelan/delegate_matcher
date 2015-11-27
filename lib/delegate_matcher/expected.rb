module RSpec
  module Matchers
    module DelegateMatcher
      class Expected
        attr_accessor :delegator
        attr_accessor :method
        attr_accessor :delegate
        attr_accessor :delegate_method
        attr_accessor :nil_check

        def delegate_method
          @via || @delegate_method || @method
        end
      end
    end
  end
end
