require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      module ToMethod
        describe 'delegation to a method' do
          class Post
            include PostMethods

            def self.author
              @author ||= Author.new
            end
          end

          subject { Post }

          let(:receiver) { :author }

          it_behaves_like 'a simple delegator' do
            before do
              class Post
                def self.name
                  author.name
                end
              end
            end
            include_examples 'a delegator without a nil check'
          end

          it_behaves_like 'a delegator with a nil check' do
            before do
              class Post
                def self.name
                  author.name if author
                end
              end
            end
          end

          it_behaves_like 'a delegator with args and a block' do
            before do
              class Post
                def self.name(*args, &block)
                  author.name(*args, &block)
                end
              end
            end
          end

          it_behaves_like 'a delegator with a different method name', :other_name do
            before do
              class Post
                def self.name
                  author.other_name
                end
              end
            end
          end

          it_behaves_like 'a delegator with a prefix', 'author' do
            before do
              class Post
                def self.author_name
                  author.name
                end
              end
            end
            it { should delegate(:name).to(:author).with_prefix  }
          end

          it_behaves_like 'a delegator with a different return value', 'Ann Rand' do
            before do
              class Post
                def self.name
                  author.name
                  'Ann Rand'
                end
              end
            end
          end
        end
      end
    end
  end
end
