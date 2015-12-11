require 'rspec/matchers'

module RSpec
  module Matchers
    define(:delegate) do |method_name|
      match do |subject|
        delegation_ok?(method_name, subject)
      end

      description do
        "delegate #{dispatcher.description} to #{delegate_description}#{expected.options_description}"
      end

      def failure_message
        delegation.failure_message(false) || super
      end

      def failure_message_when_negated
        delegation.failure_message(true) || super
      end

      chain(:to)              { |to|               expected.to          = to }
      chain(:as)              { |as|               expected.as          = as }
      chain(:allow_nil)       { |allow_nil = true| expected.allow_nil   = allow_nil }
      chain(:with_prefix)     { |prefix = nil|     expected.prefix      = prefix }
      chain(:with)            { |*args|            expected.args      ||= args; expected.as_args = args }
      chain(:with_a_block)    {                    expected.block       = true  }
      chain(:without_a_block) {                    expected.block       = false }
      chain(:without_return)  {                    expected.skip_return_check  = true }

      alias_method :with_block,    :with_a_block
      alias_method :without_block, :without_a_block

      private

      def delegation_ok?(method_name, subject)
        fail 'need to provide a "to"' unless expected.to

        dispatcher.subject   = subject
        expected.method_name = method_name

        delegation.ok?
      end

      def dispatcher
        @dispatcher ||= DelegateMatcher::Dispatcher.new(expected)
      end

      def expected
        @expected ||= DelegateMatcher::Expected.new
      end

      def delegation
        @delegation ||= DelegateMatcher::Delegation.new(expected, dispatcher)
      end

      # rubocop:disable Metrics/AbcSize
      def delegate_description
        case
        when !expected.args.eql?(expected.as_args)
          "#{expected.to}.#{expected.as}#{expected.as_argument_description}"
        when expected.as.to_s.eql?(dispatcher.method_name)
          "#{expected.to}"
        else
          "#{expected.to}.#{expected.as}"
        end
      end
    end
  end
end

# TODO: Specs for failure messages
# TODO: Handle delegation to a class method?
# TODO: How to handle delegation is delegate_double is called with something else
# TODO: Add 'as' logic to description
