require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      describe 'class delegation' do
        let(:klass) do
          Class.new do
            include PostMethods

            const_set(:AUTHOR, Author.new)

            def author
              self.class.const_get(:AUTHOR)
            end

            def name
              author.name
            end

            def name_allow_nil
              author.name if author
            end
          end
        end

        subject { klass.new }

        let(:receiver) { :AUTHOR }

        it_behaves_like 'a basic delegator'
        it_behaves_like 'a delegator without a nil check'
        it_behaves_like 'a delegator with a nil check'
      end
    end
  end
end
