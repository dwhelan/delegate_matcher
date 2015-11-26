require 'rspec/matchers'

# rubocop:disable Metrics/ModuleLength
module RSpec
  module Matchers
    define(:delegate) do |method|
      match do |delegator|
        fail 'need to provide a "to"' unless delegate

        @method    = method
        @delegator = delegator

        delegation_ok?
      end

      description do
        "delegate #{delegator_description} to #{delegate_description}#{nil_description}#{block_description}"
      end

      def failure_message
        return matcher.failure_message(false) || super if matcher

        failure_message_details(false) || super
      end

      def failure_message_when_negated
        return matcher.failure_message(true) || super if matcher

        failure_message_details(true) || super
      end

      chain(:to)              { |delegate|         @delegate           = delegate }
      chain(:to_any)          { |delegate|         @delegate           = delegate; @via = :any? }
      chain(:to_all)          { |delegate|         @delegate           = delegate; @via = :all? }
      chain(:as)              { |delegate_method|  @delegate_method    = delegate_method }
      chain(:allow_nil)       { |allow_nil = true| @expected_nil_check = allow_nil }
      chain(:with_prefix)     { |prefix = nil|     @prefix             = prefix || delegate.to_s.sub(/@/, '') }
      chain(:with)            { |*args|            @expected_args      = args; @args ||= args }
      chain(:with_a_block)    {                    @expected_block     = true  }
      chain(:without_a_block) {                    @expected_block     = false }
      chain(:without_return)  {                    @skip_return_check  = true }

      alias_method :with_block,    :with_a_block
      alias_method :without_block, :without_a_block

      private

      def delegation_ok?
        return matcher.delegation_ok? if matcher
        allow_nil_ok? && delegate? && arguments_ok? && block_ok? && return_value_ok?
      end

      attr_reader :method, :delegator, :delegate, :prefix, :args
      attr_reader :expected_nil_check, :actual_nil_check
      attr_reader :expected_args,      :actual_args
      attr_reader :expected_block,     :actual_block
      attr_reader :actual_return_value
      attr_reader :skip_return_check
      attr_accessor :matcher

      def matcher
        @matcher ||= begin
          case
          when delegate_is_a_class_variable?
            create_matcher(DelegateMatcher::DelegateToClassVariable)
          when delegate_is_an_instance_variable?
            create_matcher(DelegateMatcher::DelegateToInstanceVariable)
          when delegate_is_a_constant?
            create_matcher(DelegateMatcher::DelegateToConstant)
          when delegate_is_a_method?
            create_matcher(DelegateMatcher::DelegateToMethod)
          else
            create_matcher(DelegateMatcher::DelegateToObject)
          end
        end
      end

      def create_matcher(klass)
        klass.new.tap do |matcher|
          matcher.expected_nil_check = expected_nil_check
          matcher.via = @via
          matcher.delegate = delegate
          matcher.delegate_method = @delegate_method
          matcher.method = method
          matcher.delegator = delegator
          matcher.delegator_method = delegator_method
          matcher.args = args
          matcher.skip_return_check = skip_return_check
          matcher.expected_args = expected_args
          matcher.expected_block = expected_block
        end
      end

      def delegate_is_a_class_variable?
        delegate.to_s.start_with?('@@')
      end

      def delegate_is_an_instance_variable?
        delegate.to_s[0] == '@'
      end

      def delegate_is_a_constant?
        (delegate.is_a?(String) || delegate.is_a?(Symbol)) && (delegate.to_s =~ /^[A-Z]/)
      end

      def delegate_is_a_method?
        delegate.is_a?(String) || delegate.is_a?(Symbol)
      end

      def delegator_method
        @delegator_method || (prefix ? :"#{prefix}_#{method}" : method)
      end

      def delegate_method
        @via || @delegate_method || method
      end

      def call
        @actual_return_value = delegator.send(delegator_method, *args, &block)
        @delegated
      end

      def block
        @block ||= proc {}
      end

      def delegate_double
        double('delegate').tap { |delegate| stub_delegation(delegate) }
      end

      def delegator_description
        "#{delegator_method}#{argument_description(args)}"
      end

      def delegate_description
        case
        when !args.eql?(expected_args)
          "#{@delegate}.#{delegate_method}#{argument_description(expected_args)}"
        when delegate_method.eql?(delegator_method)
          "#{@delegate}"
        else
          "#{@delegate}.#{delegate_method}"
        end
      end

      def argument_description(args)
        args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
      end

      def nil_description
        case
        when expected_nil_check.nil?
          ''
        when expected_nil_check
          ' with nil allowed'
        else
          ' with nil not allowed'
        end
      end

      def block_description
        case
        when expected_block.nil?
          ''
        when expected_block
          ' with a block'
        else
          ' without a block'
        end
      end

      def failure_message_details(negated)
        message = [
          argument_failure_message(negated),
          block_failure_message(negated),
          return_value_failure_message(negated),
          allow_nil_failure_message(negated)
        ].reject(&:empty?).join(' and ')
        message.empty? ? nil : message
      end

      def argument_failure_message(negated)
        case
        when expected_args.nil? || negated ^ arguments_ok?
          ''
        else
          "was called with #{argument_description(actual_args)}"
        end
      end

      def block_failure_message(negated)
        case
        when expected_block.nil? || (negated ^ block_ok?)
          ''
        when negated
          "a block was #{expected_block ? '' : 'not '}passed"
        when expected_block
          actual_block.nil? ? 'a block was not passed' : "a different block #{actual_block} was passed"
        else
          'a block was passed'
        end
      end

      def return_value_failure_message(_negated)
        case
        when !@delegated || return_value_ok?
          ''
        else
          format('a return value of %p was returned instead of the delegate return value', actual_return_value)
        end
      end

      def allow_nil_failure_message(negated)
        case
        when expected_nil_check.nil? || negated ^ allow_nil_ok?
          ''
        when !@return_value_when_delegate_nil.nil?
          'did not return nil'
        when negated
          "#{delegate} was #{expected_nil_check ? '' : 'not '}allowed to be nil"
        else
          "#{delegate} was #{expected_nil_check ? 'not ' : ''}allowed to be nil"
        end
      end
    end
  end
end

# TODO: Put all settings in Struct or OpenStruct
# TODO: How to handle delegation is delegate_double is called with something else
# TODO: Add 'as' logic to description
# TODO: Add 'via' logic to description
