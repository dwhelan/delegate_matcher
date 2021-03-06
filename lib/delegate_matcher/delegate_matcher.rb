require 'rspec/matchers'

module RSpec
  module Matchers
    define(:delegate) do |method_name|
      match do |subject|
        fail 'need to provide a "to"' unless expected.to
        expected.subject = subject
        delegation.ok?
      end

      description do
        expected.description
      end

      def failure_message
        delegation.failure_message(false) || super
      end

      def failure_message_when_negated
        delegation.failure_message(true) || super
      end

      chain(:to)              { |*to|              expected.to           = *to; expected.method_name = method_name }
      chain(:as)              { |as|               expected.as           = as }
      chain(:allow_nil)       { |allow_nil = true| expected.allow_nil    = allow_nil }
      chain(:with_prefix)     { |prefix = nil|     expected.prefix       = prefix }
      chain(:with)            { |*args|            expected.args         = args }
      chain(:with_a_block)    { |&block|           expected.block        = block || true  }
      chain(:without_a_block) {                    expected.block        = false }
      chain(:without_return)  {                    expected.check_return = false }
      chain(:and_return)      { |value|            expected.return_value = value }

      alias_method :with_block,    :with_a_block
      alias_method :without_block, :without_a_block

      private

      def delegation
        @delegation ||= DelegateMatcher::Delegation.new(expected)
      end

      def expected
        @expected ||= DelegateMatcher::Expected.new
      end
    end
  end
end
