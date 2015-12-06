require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      module ToConstant
        describe 'delegation to a constant' do
          class Post
            AUTHOR = Author.new
          end

          subject { Post.new }

          let(:method_name) { :name   }
          let(:receiver)    { :AUTHOR }

          [:AUTHOR, 'AUTHOR'].each do |constant|
            let(:receiver) { constant }

            it_behaves_like 'a simple delegator' do
              before do
                class Post
                  def name
                    AUTHOR.name
                  end
                end
              end
              include_examples 'a delegator without a nil check'
            end

            it_behaves_like 'a delegator with a nil check' do
              before do
                class Post
                  def name
                    AUTHOR.name if AUTHOR
                  end
                end
              end
            end

            it_behaves_like 'a delegator with args and a block', :arg1 do
              before do
                class Post
                  def name(*args, &block)
                    AUTHOR.name(*args, &block)
                  end
                end
              end
            end

            it_behaves_like 'a delegator with a different method name', :other_name do
              before do
                class Post
                  def name
                    AUTHOR.other_name
                  end
                end
              end
            end

            it_behaves_like 'a delegator with a prefix', 'author' do
              before do
                class Post
                  def author_name
                    AUTHOR.name
                  end
                end
              end
              it { should delegate(method_name).to(receiver).with_prefix  }
            end

            it_behaves_like 'a delegator with a different return value', :other_name do
              before do
                class Post
                  def name
                    AUTHOR.name
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
end
