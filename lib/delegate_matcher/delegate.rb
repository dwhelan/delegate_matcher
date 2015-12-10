module RSpec
  module Matchers
    module DelegateMatcher
      class Delegate
        class << self
          def for(sender, name)
            case
            when !is_a_string_or_symbol(name)
              name
            when is_a_class_variable?(name)
              sender.class.class_variable_get(name)
            when is_an_instance_variable?(name)
              sender.instance_variable_get(name)
            when is_a_constant?(name)
              sender.class.const_get(name)
            else
              sender.send(name)
            end
          end

          private

          def is_a_string_or_symbol(name)
            name.is_a?(String) || name.is_a?(Symbol)
          end

          def is_a_class_variable?(name)
            name.to_s.start_with?('@@')
          end

          def is_an_instance_variable?(name)
            name.to_s.start_with?('@')
          end

          def is_a_constant?(name)
            name.to_s.start_with?('@')
          end

          def is_a_constant?(name)
            name.to_s =~ /^[A-Z]/
          end
        end
      end
    end
  end
end
