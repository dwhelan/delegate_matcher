module RSpec
  module Matchers
    module DelegateMatcher
      class Expected
        attr_accessor :method

        attr_accessor :delegate
        attr_accessor :args

        attr_accessor :block
        attr_accessor :nil_check
        attr_accessor :skip_return_check

        def method
          @delegate_method || @method
        end

        def argument_description
          args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
        end
      end
    end
  end
end
