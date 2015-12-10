module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateFactory
        class << self
          def matcher_for(delegate, *args)
            klass = case
                    when delegate_is_a_method?(delegate)
                      DelegateTo
                    else
                      DelegateToObject
                    end
            klass.new(*args)
          end

          private

          def delegate_is_a_method?(delegate)
            delegate.is_a?(String) || delegate.is_a?(Symbol)
          end
        end
      end
    end
  end
end
