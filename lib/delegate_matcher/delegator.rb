module RSpec
  module Matchers
    module DelegateMatcher
      class Delegator
        attr_accessor :sender
        attr_accessor :prefix
        attr_accessor :method
        attr_accessor :args

        def description
          "#{method}#{argument_description}"
        end

        def argument_description
          args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
        end

        def method
          prefix ? :"#{prefix}_#{@method}" : @method
        end
      end
    end
  end
end
