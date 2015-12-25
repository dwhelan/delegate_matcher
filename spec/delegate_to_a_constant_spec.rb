require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      describe 'class delegation' do
        # Note that defining Post as an anonymous class caused the constant AUTHOR to not be available,
        # so we create an explicit Post class and remove it after all specs are run
        before(:all) do
          class Post
            include PostMethods

            AUTHOR = Author.new

            def name
              AUTHOR.name
            end

            def name_allow_nil
              AUTHOR.name if AUTHOR
            end
          end
        end

        subject { Post.new }

        let(:receiver) { :AUTHOR }

        it_behaves_like 'a basic delegator'
        it_behaves_like 'a delegator without a nil check'
        it_behaves_like 'a delegator with a nil check2'

        after(:all) { DelegateMatcher.module_eval { remove_const :Post } }
      end
    end
  end
end
