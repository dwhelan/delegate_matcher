module RSpec
  module Matchers
    module DelegateMatcher
      class Delegate
        class << self
          def for(sender, name_or_object)
            return name_or_object unless name_or_object.is_a?(String) || name_or_object.is_a?(Symbol)

            name = name_or_object.to_s

            case
            when name.start_with?('@@')
              sender.class.class_variable_get(name)
            when name.start_with?('@')
              sender.instance_variable_get(name)
            when name =~ /^[A-Z]/
              sender.class.const_get(name)
            else
              sender.send(name)
            end
          end
        end
      end
    end
  end
end
