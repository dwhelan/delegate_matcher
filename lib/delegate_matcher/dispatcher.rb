module RSpec
  module Matchers
    module DelegateMatcher
      class Dispatcher
        attr_accessor :subject, :args
        attr_writer :method_name, :block
        attr_reader :return_value

        def initialize(options)
          @options = options
        end

        def call
          self.return_value = subject.send(method_name, *args, &block)
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

        private

        attr_writer :return_value
      end
    end
  end
end
