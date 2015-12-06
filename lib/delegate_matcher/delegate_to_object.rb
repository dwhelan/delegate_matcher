module RSpec
  module Matchers
    module DelegateMatcher
      class DelegateToObject < DelegateTo
        def receiver
          fail %(cannot verify "allow_nil" expectations when delegating to an object) unless expected.nil_check.nil?
          expected.delegate
        end

        def default_prefix
          fail 'must use an explicit prefix when expecting delegating to an object with a prefix'
        end
      end
    end
  end
end
