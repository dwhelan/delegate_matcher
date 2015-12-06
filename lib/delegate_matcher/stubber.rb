module RSpec
  module Matchers
    module DelegateMatcher
      class Stubber
        include RSpec::Mocks::ExampleMethods

        def stub(sender, name, value, &block)
          case
          when is_a_class_variable?(name)
            stub_class_variable(sender, name, value, &block)
          when is_an_instance_variable?(name)
            stub_instance_variable(sender, name, value, &block)
          when is_a_constant?(name)
            stub_constant(sender, name, value, &block)
          when is_a_method?(name)
            stub_method(sender, name, value, &block)
          else
            stub_object(sender, name, value, &block)
          end
        end

        private

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
          (name.is_a?(String) || name.is_a?(Symbol)) && name.to_s =~ /^[A-Z]/
        end

        def is_a_method?(name)
          name.is_a?(String) || name.is_a?(Symbol)
        end

        def stub_class_variable(sender, name, value, &block)
          sender.class.class_variable_get(name)
        # klass = sender.class
        # original_value = klass.class_variable_get(name)
        #   klass.class_variable_set(name, value)
        #   block.call
        # ensure
        #   klass.class_variable_set(name, original_value)
        end

        def stub_instance_variable(sender, name, value, &block)
          sender.instance_variable_get(name)
        #   original_value = sender.instance_variable_get(name)
        #   sender.instance_variable_set(name, value)
        #   block.call
        # ensure
        #   sender.instance_variable_set(name, original_value)
        end

        def stub_constant(sender, name, value, &block)
          sender.class.const_get(name)
          # stub_const("#{sender.class}::#{name}", value)
          # block.call
        end

        def stub_method(sender, name, value, &block)
          sender.send name
          # allow(sender).to receive(name) { value }
          # block.call
        end

        def stub_object(sender, name, value, &block)
          allow(sender).to receive(name) { value }
          block.call
        end
      end
    end
  end
end
