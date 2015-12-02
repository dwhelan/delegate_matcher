module RSpec
  module Matchers
    module DelegateMatcher
      class Delegator
        attr_writer :method
        attr_accessor :sender, :prefix, :args, :return_value

        def call
          self.return_value = sender.send(method, *args, &block)
        end

        def method
          prefix ? :"#{prefix}_#{@method}" : @method
        end

        def ensure_valid_delegate_method(delegate)
          fail "#{sender.inspect} does not respond to #{delegate}" unless sender.respond_to?(delegate, true)
          fail "#{sender.inspect}'s' #{delegate} method expects parameters" unless [0, -1].include?(sender.method(delegate).arity)
        end

        def block
          @block ||= proc {}
        end

        def description
          "#{method}#{argument_description}"
        end

        def argument_description
          args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
        end
      end
    end
  end
end
