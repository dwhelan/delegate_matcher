require 'rspec/matchers'
require 'forwardable'

module RSpec
  module Matchers
    module DelegateMatcher
      # rubocop:disable Metrics/ClassLength
      class DelegateTo
        attr_accessor :delegator_method
        attr_accessor :actual_args
        attr_accessor :args
        attr_accessor :expected_block
        attr_accessor :actual_block

        attr_accessor :delegate_method
        attr_accessor :actual_return_value
        attr_accessor :expected
        attr_accessor :delegator

        include RSpec::Mocks::ExampleMethods
        RSpec::Mocks::Syntax.enable_expect(self)

        extend Forwardable

        delegate delegator: :expected
        delegate delegate: :expected

        def initialize(expected, delegator)
          self.expected  = expected
          self.delegator = delegator
        end

        def delegate_double
          double('delegate').tap { |delegate| stub_delegation(delegate) }
        end

        def delegate_method
          expected.delegate_method || expected.method
        end

        def stub_delegation(delegate)
          @delegated = false
          allow(delegate).to(receive(delegate_method)) do |*args, &block|
            @actual_args  = args
            @actual_block = block
            @delegated    = true
            expected_return_value
          end
        end

        def call
          @actual_return_value = delegator.send(delegator_method, *expected.delegator_args, &block)
          @delegated
        end

        def block
          @block ||= proc {}
        end

        def expected_return_value
          self
        end

        def ensure_allow_nil_is_not_specified_for(target)
          fail %(cannot verify "allow_nil" expectations when delegating to #{target}) unless expected.nil_check.nil?
        end

        def argument_description(args)
          args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
        end

        def failure_message(negated)
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
          when expected.delegate_args.nil? || negated ^ arguments_ok?
            ''
          else
            "was called with #{argument_description(actual_args)}"
          end
        end

        def block_failure_message(negated)
          case
          when expected.block.nil? || (negated ^ block_ok?)
            ''
          when negated
            "a block was #{expected.block ? '' : 'not '}passed"
          when expected.block
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
          when expected.nil_check.nil? || negated ^ allow_nil_ok?
            ''
          when !@return_value_when_delegate_nil.nil?
            'did not return nil'
          when negated
            "#{delegate} was #{expected.nil_check ? '' : 'not '}allowed to be nil"
          else
            "#{delegate} was #{expected.nil_check ? 'not ' : ''}allowed to be nil"
          end
        end

        def delegation_ok?
          allow_nil_ok? && do_delegate && arguments_ok? && block_ok? && return_value_ok?
        end

        # TODO: pernaps move delegation earlier
        def allow_nil_ok?
          return true if expected.nil_check.nil?
          return true unless delegate.is_a?(String) || delegate.is_a?(Symbol)

          begin
            actual_nil_check = true
            do_delegate(nil)
            @return_value_when_delegate_nil = actual_return_value
          rescue NoMethodError
            actual_nil_check = false
          end

          expected.nil_check == actual_nil_check && @return_value_when_delegate_nil.nil?
        end

        def arguments_ok?
          expected.delegate_args.nil? || actual_args.eql?(expected.delegate_args)
        end

        def block_ok?
          case
          when expected.block.nil?
            true
          when expected.block
            actual_block == block
          else
            actual_block.nil?
          end
        end

        def return_value_ok?
          expected.skip_return_check || actual_return_value == expected_return_value
        end
      end
    end
  end
end

# TODO: How to handle delegation is delegate_double is called with something else
# TODO: Add 'as' logic to description