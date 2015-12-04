module RSpec
  module Matchers
    module DelegateMatcher
      module Stubber
        def stub(sender, name, value, &block)
          original_value = sender.instance_variable_get(name)
          sender.instance_variable_set(name, value)
          block.call
        ensure
          sender.instance_variable_set(name, original_value)
        end

        module_function :stub
      end
    end
  end
end
