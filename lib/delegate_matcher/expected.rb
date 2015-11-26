module RSpec
  module Matchers
    module DelegateMatcher
      class Expected
        attr_accessor :delegator, :method
        attr_accessor :delegate
      end
    end
  end
end
