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

        def description
          case
          when !args.eql?(to_args)
            "#{to}.#{as}#{argument_description}"
          when to.eql?(dispatcher.method_name)
            "#{to}"
          else
            "#{to}.#{as}"
          end
        end

        def argument_description
          args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
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
