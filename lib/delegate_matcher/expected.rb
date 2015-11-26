module RSpec
  module Matchers
    module DelegateMatcher
      class Expected
        attr_accessor :method, :delegator
      end
    end
  end
end
