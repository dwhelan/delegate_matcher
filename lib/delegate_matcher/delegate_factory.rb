module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateFactory
        class << self
          def matcher_for(delegate, *args)
            klass = case
                    # when delegate_is_a_class_variable?(delegate)
                    #   DelegateToClassVariable
                    when delegate_is_an_instance_variable?(delegate)
                      DelegateToInstanceVariable
                    when delegate_is_a_constant?(delegate)
                      DelegateToConstant
                    when delegate_is_a_method?(delegate)
                      DelegateToMethod
                    else
                      DelegateToObject
                    end
            klass.new(*args)
          end

          private

          # def delegate_is_a_class_variable?(delegate)
          #   delegate.to_s.start_with?('@@')
          # end
          #
          def delegate_is_an_instance_variable?(delegate)
            delegate.to_s[0] == '@'
          end

          def delegate_is_a_constant?(delegate)
            (delegate.is_a?(String) || delegate.is_a?(Symbol)) && delegate.to_s =~ /^[A-Z]/
          end

          def delegate_is_a_method?(delegate)
            delegate.is_a?(String) || delegate.is_a?(Symbol)
          end
        end
      end
    end
  end
end
