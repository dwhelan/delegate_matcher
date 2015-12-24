module RSpec
  module Matchers
    module DelegateMatcher
      class Expected
        include Block

        attr_accessor :subject, :to, :method_name, :as, :allow_nil, :check_return, :return_value
        attr_reader   :args

        def initialize
          self.check_return = true
        end

        def prefix=(prefix)
          @has_prefix = true
          @prefix     = prefix
        end

        def prefix
          case
          when !@has_prefix
            ''
          when @prefix
            "#{@prefix}_"
          when to[0].is_a?(String) || to[0].is_a?(Symbol)
            to[0].to_s.delete('@').downcase + '_'
          else
            ''
          end
        end

        def args=(args)
          @args_set ? @as_args = args : @args = args
          @args_set = true
        end

        def as_args
          @as_args || args
        end

        def as
          @as || method_name
        end

        def delegator_method_name
          "#{prefix}#{method_name}"
        end

        def description
          "delegate #{delegator_description} to #{delegate_description}#{options_description}"
        end

        def to_description
          to.join(',')
        end

        private

        def delegator_description
          "#{delegator_method_name}#{argument_description}"
        end

        def delegate_description
          %("#{to_description}") +
            case
            when !args.eql?(as_args)
              ".#{as}#{as_argument_description}"
            when as.to_s.eql?(delegator_method_name)
              ''
            else
              ".#{as}"
            end
        end

        def as_argument_description
          argument_description(as_args)
        end

        def argument_description(arguments = args)
          case
          when arguments.nil?
            ''
          when arguments.length == 1 && arguments[0].is_a?(RSpec::Mocks::ArgumentMatchers::SingletonMatcher)
            "(#{arguments[0].description})"
          else
            "(#{arguments.map { |a| format('%p', a) }.join(', ')})"
          end
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
          when block == true
            ' with a block'
          when block == false
            ' without a block'
          else
            " with block \"#{block_source}\""
          end
        end

        def return_value_description
          case
          when return_value
            " and return \"#{return_value}\""
          when !check_return
            ' without using delegate return value'
          else
            ''
          end
        end
      end
    end
  end
end
