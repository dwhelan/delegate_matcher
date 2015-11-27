require 'rspec/matchers'

# rubocop:disable Metrics/ModuleLength
module RSpec
  module Matchers
    define(:delegate) do |method|
      match do |delegator|
        fail 'need to provide a "to"' unless expected.delegate

        expected.method    = method
        expected.delegator = delegator

        matcher.delegation_ok?
      end

      description do
        "delegate #{delegator_description} to #{delegate_description}#{nil_description}#{block_description}"
      end

      def failure_message
        matcher.failure_message(false) || super
      end

      def failure_message_when_negated
        matcher.failure_message(true) || super
      end

      chain(:to)              { |to|               expected.delegate   = to }
      chain(:as)              { |as|               expected.delegate_method    = as }
      chain(:allow_nil)       { |allow_nil = true| expected.nil_check  = allow_nil }
      chain(:with_prefix)     { |prefix = nil|     expected.prefix             = prefix  }
      chain(:with)            { |*args|            expected.delegate_args       = args; expected.delegator_args ||= args }
      chain(:with_a_block)    {                    expected.block      = true  }
      chain(:without_a_block) {                    expected.block      = false }
      chain(:without_return)  {                    expected.skip_return_check  = true }

      alias_method :with_block,    :with_a_block
      alias_method :without_block, :without_a_block

      private

      attr_accessor :matcher

      def matcher
        @matcher ||= begin
          klass = case
                  when delegate_is_a_class_variable?
                    DelegateMatcher::DelegateToClassVariable
                  when delegate_is_an_instance_variable?
                    DelegateMatcher::DelegateToInstanceVariable
                  when delegate_is_a_constant?
                    DelegateMatcher::DelegateToConstant
                  when delegate_is_a_method?
                    DelegateMatcher::DelegateToMethod
                  else
                    DelegateMatcher::DelegateToObject
                  end
          create_matcher(klass)
        end
      end

      def expected
        @expected ||= DelegateMatcher::Expected.new
      end

      def create_matcher(klass)
        klass.new(expected).tap do |matcher|
          matcher.delegator_method = delegator_method
        end
      end

      def delegate_is_a_class_variable?
        delegate_name.start_with?('@@')
      end

      def delegate_is_an_instance_variable?
        delegate_name[0] == '@'
      end

      def delegate_is_a_constant?
        (expected.delegate.is_a?(String) || expected.delegate.is_a?(Symbol)) && (delegate_name =~ /^[A-Z]/)
      end

      def delegate_is_a_method?
        expected.delegate.is_a?(String) || expected.delegate.is_a?(Symbol)
      end

      def delegator_method
        @delegator_method || (expected.prefix ? :"#{expected.prefix}_#{expected.method}" : expected.method)
      end

      def delegate_method
        expected.delegate_method || expected.method
      end

      def delegator_description
        "#{delegator_method}#{argument_description(expected.delegator_args)}"
      end

      # rubocop:disable Metrics/AbcSize
      def delegate_description
        case
        when !expected.delegate_args.eql?(expected.delegator_args)
          "#{expected.delegate}.#{delegate_method}#{argument_description(expected.delegate_args)}"
        when delegate_method.eql?(delegator_method)
          "#{expected.delegate}"
        else
          "#{expected.delegate}.#{expected.delegate_method}"
        end
      end

      delegate :argument_description, to: :matcher

      # def argument_description(args)
      #   args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
      # end

      def nil_description
        case
        when expected.nil_check.nil?
          ''
        when expected.nil_check
          ' with nil allowed'
        else
          ' with nil not allowed'
        end
      end

      def block_description
        case
        when expected.block.nil?
          ''
        when expected.block
          ' with a block'
        else
          ' without a block'
        end
      end
    end

    def delegate_name
      expected.delegate.to_s
    end
  end
end

# TODO: Put all settings in Struct or OpenStruct
# TODO: How to handle delegation is delegate_double is called with something else
# TODO: Add 'as' logic to description
