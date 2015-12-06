require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      module ToInstanceVariable
        describe 'delegation to an instance variable' do
          class Post
            def initialize
              @author = Author.new
            end
          end

          subject { Post.new }

          let(:method_name) { :name   }

          [:@author, '@author'].each do |instance_variable|
            let(:receiver) { instance_variable }

            it_behaves_like 'a simple delegator' do
              before do
                class Post
                  def name
                    @author.name
                  end
                end
              end
              include_examples 'a delegator without a nil check'
            end

            it_behaves_like 'a delegator with a nil check' do
              before do
                class Post
                  def name
                    @author.name if @author
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
              it { should delegate(method_name).to(receiver).with_prefix  }
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
end
