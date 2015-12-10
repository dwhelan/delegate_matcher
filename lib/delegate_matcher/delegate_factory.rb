module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateFactory
        class << self
          def matcher_for(delegate, *args)
            DelegateTo.new(*args)
          end
        end
      end
    end
  end
end
