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
          self.delegate   = expected.to.map { |to| StubDelegate.new(expected, to) }
        end

        def delegation_ok?
          dispatcher.call
          delegate.all?(&:received)
        end

        def ok?
          allow_nil_ok? && delegation_ok? && arguments_ok? && block_ok? && return_value_ok?
        end

        def allow_nil_ok?
          return true if expected.allow_nil.nil?

          begin
            expected.to.each { |to| NilDelegate.new(expected, to) { dispatcher.call } }
            allow_nil = true
          rescue NoMethodError
            allow_nil = false
          end

          allow_nil == expected.allow_nil
        end

        def arguments_ok?
          args_matcher = Mocks::ArgumentListMatcher.new(*expected.as_args)
          delegate.all? { |delegate| args_matcher.args_match?(*delegate.args) }
        end

        # rubocop:disable Metrics/AbcSize
        def block_ok?
          case
          when expected.block.nil?
            true
          when expected.block == false
            delegate.all? { |d| d.block.nil? }
          when expected.block == true
            delegate.all? { |d| d.block == dispatcher.block }
          else
            delegate.all? { |d| d.block_source == expected.block_source }
          end
        end

        def return_value_ok?
          case
          when !expected.check_return then true
          when expected.return_value.nil? then  dispatcher.return_value == delegate_return_value
          else dispatcher.return_value == expected.return_value
          end
        end

        def delegate_return_value
          delegate.length == 1 ? delegate[0].return_value : delegate.map(&:return_value)
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
            "was called with #{delegate[0].argument_description}"
          end
        end

        def block_failure_message(negated)
          proc_source = ProcSource.new(delegate[0].block)
          case
          when expected.block.nil? || negated ^ block_ok?
            ''
          when negated
            "a block was #{expected.block ? '' : 'not '}passed"
          when expected.block
            delegate.all? { |d| d.block.nil? } ? 'a block was not passed' : "a different block '#{proc_source}' was passed"
          else
            %(a block #{proc_source} was passed)
          end
        end

        def return_value_failure_message(negated)
          case
          when !delegate.any?(&:received) || negated ^ return_value_ok?
            ''
          when negated
            ''
          when !expected.return_value.nil?
            "a value of \"#{dispatcher.return_value}\" was returned instead of \"#{expected.return_value}\""
          else
            "a value of \"#{dispatcher.return_value}\" was returned instead of \"#{delegate_return_value}\""
          end
        end

        def allow_nil_failure_message(negated)
          case
          when expected.allow_nil.nil? || negated ^ allow_nil_ok?
            ''
          when negated
            %("#{expected.to_description}" was #{expected.allow_nil ? '' : 'not '}allowed to be nil)
          else
            %("#{expected.to_description}" was #{expected.allow_nil ? 'not ' : ''}allowed to be nil)
          end
        end
      end
    end
  end
end
