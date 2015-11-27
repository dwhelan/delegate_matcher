module RSpec
  module Matchers
    module DelegateMatcher
      class Expected
        attr_accessor :method

        attr_accessor :delegate
        attr_writer :delegate_method
        attr_accessor :delegate_args

        attr_accessor :block
        attr_accessor :nil_check
        attr_accessor :skip_return_check

        def delegate_method
          @delegate_method || @method
        end

        def method
          @delegate_method || @method
        end
      end
    end
  end
end
