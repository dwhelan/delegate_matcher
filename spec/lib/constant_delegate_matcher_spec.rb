# noinspection RubyResolve

require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      module ToConstant

        describe 'DelegateTo matcher with constants' do

          class Author
            def name
              'Ann Rand'
            end
          end

          class Post
            AUTHOR = Author.new

            def name
              AUTHOR.name
            end
          end

          subject { Post.new }

          it { should delegate(:name).to(:AUTHOR)   }
          it { should delegate(:name).to('AUTHOR')   }

          context 'simple delegation' do
            include_examples 'disallow_nil',    :name, :AUTHOR
            include_examples 'without a block', :name, :AUTHOR
          end

          context 'delegation with nil check' do
            before do
              class Post
                def name
                  AUTHOR.name if AUTHOR
                end
              end
            end

            include_examples 'allow_nil', :name, :AUTHOR
          end

          describe 'delegation with a block' do
            before do
              class Post
                def name(&block)
                  AUTHOR.name(&block)
                end
              end
            end

            include_examples 'with a block', :name, :AUTHOR
          end
        end
      end
    end
  end
end
