require 'rspec/matchers'

module RSpec
  module Matchers
    module DelegateMatcher
      # rubocop:disable Metrics/ClassLength
      class Delegation
        attr_accessor :expected
        attr_accessor :dispatcher
        attr_accessor :actual

        def initialize(expected)
          self.expected   = expected
          self.dispatcher = DelegateMatcher::Dispatcher.new(expected)
          self.actual     = Actual.new
        end

        def delegate
          @delegate ||= Delegate.new(expected)
        end

        def delegation_ok?
          actual.stub_receive(delegate.receiver, expected.as)
          dispatcher.call
          actual.received
        end

        def ok?
          ok = allow_nil_ok? && delegation_ok?
          ok && arguments_ok? && block_ok? && return_value_ok?
        end

        # TODO: perhaps move delegation earlier
        def allow_nil_ok?
          return true if expected.allow_nil.nil?
          return true unless expected.to.is_a?(String) || expected.to.is_a?(Symbol)

          begin
            actual_nil_check = true
            delegation_ok?
            @return_value_when_delegate_nil = dispatcher.return_value
          rescue NoMethodError
            actual_nil_check = false
          end

          expected.nil_check == actual_nil_check && @return_value_when_delegate_nil.nil?
        end

        def arguments_ok?
          expected.as_args.nil? || actual.args.eql?(expected.as_args)
        end

        def block_ok?
          case
          when expected.block.nil?
            true
          when expected.block
            actual.block == dispatcher.block
          else
            actual.block.nil?
          end
        end

        def return_value_ok?
          !expected.check_return || dispatcher.return_value == actual.return_value
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
          when expected.as_args.nil? || negated ^ arguments_ok?
            ''
          else
            "was called with #{actual.argument_description}"
          end
        end

        def block_failure_message(negated)
          case
          when expected.block.nil? || (negated ^ block_ok?)
            ''
          when negated
            "a block was #{expected.block ? '' : 'not '}passed"
          when expected.block
            actual.block.nil? ? 'a block was not passed' : "a different block #{actual.block} was passed"
          else
            'a block was passed'
          end
        end

        def return_value_failure_message(_negated)
          case
          when !actual.received || return_value_ok?
            ''
          else
            format('a return value of %p was returned instead of the delegate return value', dispatcher.return_value)
          end
        end

        def allow_nil_failure_message(negated)
          case
          when expected.allow_nil.nil? || negated ^ allow_nil_ok?
            ''
          when !@return_value_when_delegate_nil.nil?
            'did not return nil'
          when negated
            "#{expected.to} was #{expected.allow_nil ? '' : 'not '}allowed to be nil"
          else
            "#{expected.to} was #{expected.allow_nil ? 'not ' : ''}allowed to be nil"
          end
        end
      end
    end
  end
end

# TODO: use default prefix with constants - lower case method prefix
# TODO: How to handle delegation is delegate_double is called with something else
# TODO: Add 'as' logic to description
