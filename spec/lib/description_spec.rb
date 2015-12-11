require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      module Description
        describe 'description' do

          class Post
            def name
              author.name
            end

            def author
              @author ||= Author.new
            end
          end

          let(:matcher) { self.class.parent_groups[1].description }
          let(:post)    { Post.new }
          subject       { eval matcher }
          before        { subject.matches? post }

          xcontext 'with allow_nil true' do
            context 'delegate(:name).to(:author).allow_nil' do
              its(:description)     { should eq 'delegate name to author with nil allowed' }
              its(:failure_message) { should match(/author was not allowed to be nil/) }
            end

            context 'delegate(:name).to(:author).allow_nil(true)' do
              its(:description)     { should eq 'delegate name to author with nil allowed' }
              its(:failure_message) { should match(/author was not allowed to be nil/) }
            end

            context 'delegate(:name_with_nil_check_and_bad_return).to(:author).allow_nil' do
              its(:failure_message) { should match(/did not return nil/) }
            end

            context 'delegate(:name_with_nil_check).to(:author).allow_nil' do
              its(:failure_message_when_negated) { should match(/author was allowed to be nil/) }
            end
          end

          xcontext 'with allow_nil false' do
            context 'delegate(:name_with_nil_check).to(:author).allow_nil(false)' do
              its(:description)     { should eq 'delegate name_with_nil_check to author with nil not allowed' }
              its(:failure_message) { should match(/author was allowed to be nil/) }
            end

            context 'delegate(:name).to(:author).allow_nil(false)' do
              its(:failure_message_when_negated) { should match(/author was not allowed to be nil/) }
            end
          end
        end
      end
    end
  end
end
