require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      module ToObject
        describe 'delegation to an object' do
          class Author
            def name
              ''
            end
          end

          class Post
            def initialize(author)
              @author = author
            end

            def name
              @author.name
            end
          end

          subject { Post.new(author) }

          let(:author)      { Author.new }
          let(:method_name) { :name      }
          let(:receiver)    { author    }

          it 'should ignore "with_prefix" unless an explicit prefix is provided' do
            should delegate(:name).to(author).with_prefix
          end

          it 'should fail it a nil check is specified' do
            expect { should delegate(:name).to(author).allow_nil }.to raise_error do |error|
              expect(error.message).to match(/cannot verify "allow_nil" expectations when delegating to an object/)
            end
          end

          it_behaves_like 'a simple delegator' do
            before do
              class Post
                def name
                  @author.name
                end
              end
            end
          end

          it_behaves_like 'a delegator with args and a block', :arg1 do
            before do
              class Post
                def name(*args, &block)
                  @author.name(*args, &block)
                end
              end
            end
          end

          it_behaves_like 'a delegator with a different method name', :other_name do
            before do
              class Post
                def name
                  @author.other_name
                end
              end
            end
          end

          it_behaves_like 'a delegator with a prefix', 'author' do
            before do
              class Post
                def author_name
                  @author.name
                end
              end
            end
          end

          it_behaves_like 'a delegator with a different return value', 'Ann Rand' do
            before do
              class Post
                def name
                  @author.name
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
