require 'rspec/matchers'
require 'proc_extensions'

module RSpec
  module Matchers
    module DelegateMatcher
      class Delegation
        attr_accessor :expected
        attr_accessor :dispatcher
        attr_accessor :delegate

        def initialize(expected)
          self.expected   = expected
          self.dispatcher = DelegateMatcher::Dispatcher.new(expected)
          self.delegate   = StubDelegate.new(expected)
        end

        def delegation_ok?
          dispatcher.call
          delegate.received
        end

        def ok?
          allow_nil_ok? && delegation_ok? && arguments_ok? && block_ok? && return_value_ok?
        end

        def allow_nil_ok?
          return true if expected.allow_nil.nil?

          begin
            NilDelegate.new(expected) { dispatcher.call }
            allow_nil = true
          rescue NoMethodError
            allow_nil = false
          end

          allow_nil == expected.allow_nil
        end

        def arguments_ok?
          expected.as_args.nil? || delegate.args.eql?(expected.as_args)
        end

        # rubocop:disable Metrics/AbcSize
        def block_ok?
          case
          when expected.block.nil?
            true
          when expected.block == false
            delegate.block.nil?
          when expected.block == true
            delegate.block == dispatcher.block
          else
            delegate.block_source == expected.block_source
          end
        end

        def return_value_ok?
          !expected.check_return || dispatcher.return_value == (expected.return_value || delegate.return_value)
        end

        def failure_message(negated)
          # TODO: Should include the line below
          # return nil if negated == delegate.received

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
            "was called with #{delegate.argument_description}"
          end
        end

        def block_failure_message(negated)
          case
          when expected.block.nil? || (negated ^ block_ok?)
            ''
          when negated
            "a block was #{expected.block ? '' : 'not '}passed"
          when expected.block
            delegate.block.nil? ? 'a block was not passed' : "a different block '#{ProcSource.new(delegate.block)}' was passed"
          else
            'a block was passed'
          end
        end

        def return_value_failure_message(_negated)
          case
          when !delegate.received || return_value_ok?
            ''
          else
            format('a return value of %p was returned instead of the delegate return value', dispatcher.return_value)
          end
        end

        def allow_nil_failure_message(negated)
          case
          when expected.allow_nil.nil? || negated ^ allow_nil_ok?
            ''
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
