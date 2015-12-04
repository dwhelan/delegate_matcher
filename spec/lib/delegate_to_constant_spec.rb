# noinspection RubyResolve

require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      module ToConstant
        describe 'DelegateTo matcher with constants' do
          class Post
            AUTHOR = Object.new
          end

          subject { Post.new }

          it_behaves_like 'a simple delegator', :name, :AUTHOR do
            before do
              class Post
                def name
                  AUTHOR.name
                end
              end
            end
          end

          it_behaves_like 'a delegator with a nil check', :name, :AUTHOR do
            before do
              class Post
                def name
                  AUTHOR.name if AUTHOR
                end
              end
            end
          end

          it_behaves_like 'a delegator with args and a block', :name, :AUTHOR, :arg1 do
            before do
              class Post
                def name(*args, &block)
                  AUTHOR.name(*args, &block)
                end
              end
            end
          end

          it_behaves_like 'a delegator with a prefix', :name, :AUTHOR do
            before do
              class Post
                def author_name(*args, &block)
                  AUTHOR.name(*args, &block)
                end
              end
            end
          end
        end
      end
    end
  end
end
