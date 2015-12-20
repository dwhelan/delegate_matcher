module RSpec
  module Matchers
    module DelegateMatcher
      class Author
        def name
        end

        def to_s
          'author'
        end
      end
    end
  end
end
