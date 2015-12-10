module RSpec
  module Matchers
    module DelegateMatcher
      class Dispatcher
        attr_writer :method_name
        attr_accessor :sender, :prefix, :args, :return_value

        def initialize(options)
          @options = options
        end

        def call
          self.return_value = sender.send(method_name, *args, &block)
        end

        def method_name
          "#{@options.prefix}#{@method_name}"
        end

        def block
          @block ||= proc {}
        end

        def description
          "#{method_name}#{argument_description}"
        end

        def argument_description
          args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
        end
      end
    end
  end
end
