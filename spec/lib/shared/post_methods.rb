module RSpec
  module Matchers
    module DelegateMatcher
      module PostMethods
        def to_s
          'post'
        end
        def inspect
          'post'
        end
      end
    end
  end
end
