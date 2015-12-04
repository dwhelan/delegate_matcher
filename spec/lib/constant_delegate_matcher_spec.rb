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
            before {
              class Post
                def name
                  AUTHOR.name
                end
              end
            }
          end

          it_behaves_like 'a delegator with a nil check', :name, :AUTHOR do
            before {
              class Post
                def name
                  AUTHOR.name if AUTHOR
                end
              end
            }
          end

          it_behaves_like 'a delegator with args', :name, :AUTHOR, :arg1 do
            before {
              class Post
                def name(*args)
                  AUTHOR.name(*args)
                end
              end
            }
          end

          it_behaves_like 'a delegator with a block', :name, :AUTHOR do
            before {
              class Post
                def name(&block)
                  AUTHOR.name(&block)
                end
              end
            }
          end

          it_behaves_like 'a delegator with args and a block', :name, :AUTHOR, :arg1 do
            before {
              class Post
                def name(*args, &block)
                  AUTHOR.name(*args, &block)
                end
              end
            }
          end
        end
      end
    end
  end
end
