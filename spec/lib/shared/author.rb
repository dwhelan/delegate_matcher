module RSpec
  module Matchers
    module DelegateMatcher
      class Author
        def name
        end

        def to_s
          'author'
        end

        def inspect
          'author'
        end
      end
    end
  end
end
