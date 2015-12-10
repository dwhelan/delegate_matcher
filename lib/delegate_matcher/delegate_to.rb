require 'rspec/matchers'

module RSpec
  module Matchers
    module DelegateMatcher
      # rubocop:disable Metrics/ClassLength
      class DelegateTo
        attr_accessor :delegated
        attr_accessor :args
         attr_accessor :expected_block

        attr_accessor :expected
        attr_accessor :dispatcher
        attr_accessor :actual

        include RSpec::Mocks::ExampleMethods
        RSpec::Mocks::Syntax.enable_expect(self)

        def initialize(expected, dispatcher)
          self.expected   = expected
          self.dispatcher = dispatcher
          self.actual   = Actual.new
        end

        def default_prefix
          expected.delegate.to_s.delete('@')
        end

        def do_delegate(&block)
          actual.stub_receive(receiver, expected.method)
          block.call
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
          when expected.args.nil? || negated ^ arguments_ok?
            ''
          else
            "was called with #{argument_description(actual.args)}"
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
          when !actual.received? || return_value_ok?
            ''
          else
            format('a return value of %p was returned instead of the delegate return value', dispatcher.return_value)
          end
        end

        def allow_nil_failure_message(negated)
          case
          when expected.nil_check.nil? || negated ^ allow_nil_ok?
            ''
          when !@return_value_when_delegate_nil.nil?
            'did not return nil'
          when negated
            "#{expected.delegate} was #{expected.nil_check ? '' : 'not '}allowed to be nil"
          else
            "#{expected.delegate} was #{expected.nil_check ? 'not ' : ''}allowed to be nil"
          end
        end

        def delegation_ok?
          ok = allow_nil_ok? && do_delegate { dispatcher.call }
          ok && actual.received? && arguments_ok? && block_ok? && return_value_ok?
        end

        # TODO: pernaps move delegation earlier
        def allow_nil_ok?
          return true if expected.nil_check.nil?
          return true unless expected.delegate.is_a?(String) || expected.delegate.is_a?(Symbol)

          begin
            actual_nil_check = true
            do_delegate(nil) { dispatcher.call }
            @return_value_when_delegate_nil = dispatcher.return_value
          rescue NoMethodError
            actual_nil_check = false
          end

          expected.nil_check == actual_nil_check && @return_value_when_delegate_nil.nil?
        end

        def arguments_ok?
          expected.args.nil? || actual.args.eql?(expected.args)
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
          expected.skip_return_check || dispatcher.return_value == actual.return_value
        end
      end
    end
  end
end

# TODO: use default prefix with constants - lower case method prefix
# TODO: How to handle delegation is delegate_double is called with something else
# TODO: Add 'as' logic to description
