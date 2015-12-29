require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      describe 'delegation to a class variable' do
        let(:klass) do
          Class.new do
            include PostMethods

            class_variable_set(:@@author, Author.new)

            def author
              self.class.class_variable_get(:@@author)
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

        let(:receiver) { :@@author }

        it_behaves_like 'a basic delegator'
        it_behaves_like 'a delegator without a nil check'
        it_behaves_like 'a delegator with a nil check'
      end
    end
  end
end
