module RSpec
  module Matchers
    module DelegateMatcher
      class Expected
        attr_accessor :method

        attr_accessor :delegate
        attr_accessor :args

        attr_accessor :block
        attr_accessor :nil_check
        attr_accessor :skip_return_check

        attr_reader   :with_prefix, :prefix

        def prefix=(prefix)
          @has_prefix = true
          @prefix      = prefix
        end

        def prefix
          return '' unless @has_prefix
          return "#{@prefix}_" if @prefix

          if delegate.is_a?(String) || delegate.is_a?(Symbol)
            delegate.to_s.delete('@').downcase + '_'
          else
            ''
          end
        end

        def argument_description
          args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
        end

        def nil_description
          case
          when nil_check.nil?
            ''
          when nil_check
            ' with nil allowed'
          else
            ' with nil not allowed'
          end
        end

        def block_description
          case
          when block.nil?
            ''
          when block
            ' with a block'
          else
            ' without a block'
          end
        end
      end
    end
  end
end
