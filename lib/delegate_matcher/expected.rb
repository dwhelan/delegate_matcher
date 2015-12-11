module RSpec
  module Matchers
    module DelegateMatcher
      class Expected
        attr_accessor :to
        attr_accessor :args, :as_args
        attr_accessor :received_args
        attr_accessor :method_name, :as
        attr_accessor :block
        attr_accessor :allow_nil
        attr_accessor :skip_return_check

        def prefix=(prefix)
          @has_prefix = true
          @prefix     = prefix
        end

        def as
          @as || method_name
        end

        def as_args
          @as_args || args
        end

        def prefix
          case
          when !@has_prefix
            ''
          when @prefix
            "#{@prefix}_"
          when to.is_a?(String) || to.is_a?(Symbol)
            to.to_s.delete('@').downcase + '_'
          else
            ''
          end
        end

        def delegator_method_name
          "#{prefix}#{method_name}"
        end

        def delegator_description
          "#{delegator_method_name}#{argument_description}"
        end

        def delegate_description
          case
          when !args.eql?(as_args)
            "#{to}.#{as}#{as_argument_description}"
          when as.to_s.eql?(delegator_method_name)
            "#{to}"
          else
            "#{to}.#{as}"
          end
        end

        def argument_description(arguments=args)
          arguments ? "(#{arguments.map { |a| format('%p', a) }.join(', ')})" : ''
        end

        def as_argument_description
          argument_description(as_args)
        end

        def options_description
          "#{nil_description}#{block_description}#{return_value_description}"
        end

        def nil_description
          case
          when allow_nil.nil?
            ''
          when allow_nil
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

        def return_value_description
          skip_return_check ? ' without using delegate return value' : ''
        end
      end
    end
  end
end
