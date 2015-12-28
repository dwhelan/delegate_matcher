require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      describe 'delegation to an instance method' do
        let(:klass) do
          Class.new do
            include PostMethods

            def initialize
              @authors = [author]
            end

            def author
              @author ||= Author.new
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

        let(:receiver) { :author }

        it_behaves_like 'a basic delegator'
        it_behaves_like 'a delegator without a nil check'
        it_behaves_like 'a delegator with a nil check'
      end
    end
  end
end
