module RSpec
  module Matchers
    module DelegateMatcher
      class Author
        attr_accessor :name

        def initialize(name = 'Catherine Asaro')
          self.name = name
        end

        def other_name
          'Other Name'
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
