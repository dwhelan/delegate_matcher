module RSpec
  module Matchers
    module DelegateMatcher
      class Author
        def initialize(name = 'Catherine Asaro')
          @name = name
        end

        def other_name
          'Other Name'
        end

        def name(*args, &_)
          "#{args.join}#{@name}"
        end

        def to_s
          "Author: #{@name}"
        end
      end
    end
  end
end
