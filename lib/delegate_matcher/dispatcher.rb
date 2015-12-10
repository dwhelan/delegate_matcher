module RSpec
  module Matchers
    module DelegateMatcher
      class Dispatcher
        attr_writer :method
        attr_accessor :sender, :prefix, :args, :return_value

        def call
          self.return_value = sender.send(method, *args, &block)
        end

        def method
          prefix ? :"#{prefix.downcase}_#{@method}" : @method
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
