module RSpec
  module Matchers
    module DelegateMatcher
      class Stubber
        class << self
          def stub(sender, name, value, &block)
            case
            when is_a_class_variable?(name)
              stub_class_variable(sender, name, value, &block)
            when is_an_instance_variable?(name)
              stub_instance_variable(sender, name, value, &block)
            else
              raise 'WTF'
            end
          end

          private

          def is_a_class_variable?(name)
            name.to_s.start_with?('@@')
          end

          def is_an_instance_variable?(name)
            name.to_s.start_with?('@')
          end


          def stub_class_variable(sender, name, value, &block)
            klass = sender.class
            original_value = klass.class_variable_get(name)
            klass.class_variable_set(name, value)
            block.call
          ensure
            klass.class_variable_set(name, original_value)
          end

          def stub_instance_variable(sender, name, value, &block)
            original_value = sender.instance_variable_get(name)
            sender.instance_variable_set(name, value)
            block.call
          ensure
            sender.instance_variable_set(name, original_value)
          end
        end
      end
    end
  end
end
