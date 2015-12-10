module RSpec
  module Matchers
    module DelegateMatcher
      class Dispatcher
        attr_writer :method
        attr_accessor :sender, :prefix, :args, :return_value

        def initialize(options)
          @options = options
        end

        def call
          # binding.pry
          self.return_value = sender.send(method, *args, &block)
        end

        def method
          "#{@options.prefix}#{@method}"
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
