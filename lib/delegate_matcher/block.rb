module RSpec
  module Matchers
    module DelegateMatcher
      module Block
        attr_accessor :block

        def block_source
          ProcSource.new(block)
        end
      end
    end
  end
end
