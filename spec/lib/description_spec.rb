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

          context 'delegate(:name).to(:author)' do
            its(:description)                  { should eq 'delegate name to author' }
            its(:failure_message_when_negated) { should match(/expected .* not to delegate name to author/) }
          end

          xcontext 'delegate(:writer).to(:author).as(:name)' do
            its(:description) { should eq 'delegate writer to author.name' }
          end

          xcontext 'delegate(:name).to(:@author)' do
            its(:description) { should eq 'delegate name to @author' }
          end

          xcontext 'delegate(:name).to(:author).with_prefix' do
            its(:description) { should eq 'delegate author_name to author.name' }
          end

          xcontext 'delegate(:name).to(:author).with_prefix("writer")' do
            its(:description) { should eq 'delegate writer_name to author.name' }
          end

          xcontext 'delegate(:writer).to(:author).as("name")' do
            its(:description) { should eq 'delegate writer to author.name' }
          end

          xcontext 'delegate(:name_with_bad_return).to(:author)' do
            its(:description)     { should eq 'delegate name_with_bad_return to author' }
            its(:failure_message) { should match(/a return value of "Ann Rand" was returned instead of the delegate return value/) }
          end

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

          xcontext 'with arguments' do
            context 'delegate(:name_with_multiple_args).with("Ms.", "Phd").to(:author)' do
              its(:description) { should eq 'delegate name_with_multiple_args("Ms.", "Phd") to author' }
            end

            context 'delegate(:name_with_different_arg_and_block).with("Ms.").to(:author)' do
              its(:description)     { should eq 'delegate name_with_different_arg_and_block("Ms.") to author' }
              its(:failure_message) { should match(/was called with \("Miss"\)/) }
            end

            context 'delegate(:name_with_different_arg_and_block).with("Ms.").to(:author).with("Miss")' do
              its(:description)                  { should eq 'delegate name_with_different_arg_and_block("Ms.") to author.name_with_different_arg_and_block("Miss")' }
              its(:failure_message_when_negated) { should match(/was called with \("Miss"\)/) }
            end

            context 'delegate(:name_with_arg2).with("The author").to(:author).as(:name_with_arg)' do
              its(:description) { should eq 'delegate name_with_arg2("The author") to author.name_with_arg' }
            end
          end

          xcontext 'with a block' do
            context 'delegate(:name).to(:author).with_a_block' do
              its(:description)     { should eq 'delegate name to author with a block' }
              its(:failure_message) { should match(/a block was not passed/) }
            end

            context 'delegate(:name_with_different_block).to(:author).with_a_block' do
              its(:failure_message) { should match(/a different block .+ was passed/) }
            end

            context 'delegate(:name_with_block).to(:author).with_a_block' do
              its(:failure_message_when_negated) { should match(/a block was passed/) }
            end

            context 'and arguments' do
              context 'delegate(:name_with_different_arg_and_block).with("Ms.").to(:author).with_a_block' do
                its(:description)     { should eq 'delegate name_with_different_arg_and_block("Ms.") to author with a block' }
                its(:failure_message) { should match(/was called with \("Miss"\) /) }
                its(:failure_message) { should match(/and a different block .+ was passed/) }
              end

              context 'delegate(:name_with_arg_and_block).to(:author).with(true).with_a_block' do
                its(:failure_message_when_negated) { should match(/was called with \(true\) /) }
                its(:failure_message_when_negated) { should match(/and a block was passed/) }
              end
            end
          end

          xcontext 'without a block' do
            context 'delegate(:name_with_block).to(:author).without_a_block' do
              its(:description)     { should eq 'delegate name_with_block to author without a block' }
              its(:failure_message) { should match(/a block was passed/) }
            end

            context 'delegate(:name_with_different_block).to(:author).without_a_block' do
              its(:failure_message) { should match(/a block was passed/) }
            end

            context 'delegate(:name).to(:author).without_a_block' do
              its(:failure_message_when_negated) { should match(/a block was not passed/) }
            end

            context 'and arguments' do
              context 'delegate(:name_with_different_arg_and_block).to(:author).with("Miss").without_a_block' do
                its(:description)     { should eq 'delegate name_with_different_arg_and_block("Miss") to author without a block' }
                its(:failure_message) { should match(/a block was passed/) }
              end

              context 'delegate(:name_with_arg).to(:author).with("Miss").without_a_block' do
                its(:failure_message_when_negated) { should match(/was called with \("Miss"\) /) }
                its(:failure_message_when_negated) { should match(/and a block was not passed/) }
              end
            end
          end
        end
      end
    end
  end
end
