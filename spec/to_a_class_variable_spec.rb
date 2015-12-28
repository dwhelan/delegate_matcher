require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      describe 'delegation to a class variable' do
        # Note that defining Post as an anonymous class caused the class variable @@author to not be available,
        # so we create an explicit Post class and remove it after all specs are run
        before(:all) do
          class Post
            include PostMethods

            # rubocop:disable Style/ClassVars
            @@author = Author.new

            def name
              @@author.name
            end

            def name_allow_nil
              @@author.name if @@author
            end
          end
        end

        subject { Post.new }

        let(:receiver) { :@@author }

        it_behaves_like 'a basic delegator'
        it_behaves_like 'a delegator without a nil check'
        it_behaves_like 'a delegator with a nil check'

        after(:all) { DelegateMatcher.module_eval { remove_const :Post } }
      end
    end
  end
end
