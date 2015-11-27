module RSpec
  module Matchers
    module DelegateMatcher
      class Expected
        attr_accessor :delegator, :method
        attr_accessor :delegate
        attr_accessor :nil_check
      end
    end
  end
end
