require 'rspec/matchers'

module RSpec
  module Matchers
    define(:delegate) do |method|
      match do |d|
        fail 'need to provide a "to"' unless expected.delegate

        expected.method ||= method
        dispatcher.sender   = d
        dispatcher.method   = method

        matcher.delegation_ok?
      end

      description do
        "delegate #{dispatcher.description} to #{delegate_description}#{expected.nil_description}#{expected.block_description}"
      end

      def failure_message
        matcher.failure_message(false) || super
      end

      def failure_message_when_negated
        matcher.failure_message(true) || super
      end

      chain(:to)              { |to|               expected.delegate  = to }
      chain(:as)              { |as|               expected.method    = as }
      chain(:allow_nil)       { |allow_nil = true| expected.nil_check = allow_nil }
      chain(:with_prefix)     { |prefix = nil|     dispatcher.prefix   = prefix || matcher.default_prefix }
      chain(:with)            { |*args|            expected.args      = args; dispatcher.args ||= args }
      chain(:with_a_block)    {                    expected.block     = true  }
      chain(:without_a_block) {                    expected.block     = false }
      chain(:without_return)  {                    expected.skip_return_check  = true }

      alias_method :with_block,    :with_a_block
      alias_method :without_block, :without_a_block

      private

      def expected
        @expected ||= DelegateMatcher::Expected.new
      end

      def dispatcher
        @dispatcher ||= DelegateMatcher::Dispatcher.new
      end

      def matcher
        @matcher ||= DelegateMatcher::DelegateFactory.matcher_for(expected.delegate, expected, dispatcher)
      end

      # rubocop:disable Metrics/AbcSize
      def delegate_description
        case
        when !expected.args.eql?(dispatcher.args)
          "#{expected.delegate}.#{expected.method}#{expected.argument_description}"
        when expected.method.eql?(dispatcher.method)
          "#{expected.delegate}"
        else
          "#{expected.delegate}.#{expected.method}"
        end
      end
    end
  end
end

# TODO: Handle delegation to a class method?
# TODO: How to handle delegation is delegate_double is called with something else
# TODO: Add 'as' logic to description
