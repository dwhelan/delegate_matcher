require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher

      describe 'delegation to an object' do
        let(:klass) do
          Class.new do
            include PostMethods

            def initialize(author)
              @author = author
            end

            def name
              @author.name
            end
          end
        end

        subject { klass.new(author) }

        let(:author)   { Author.new }
        let(:receiver) { author     }

        it_behaves_like 'a basic delegator'

        # TODO: Add checks for errors for allow nil
      end
    end
  end
end
