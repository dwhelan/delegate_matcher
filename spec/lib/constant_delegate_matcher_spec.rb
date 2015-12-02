# noinspection RubyResolve

require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher

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

      describe 'DelegateTo matcher with constants' do
        subject { Post.new }

        it { should delegate(:name).to(:AUTHOR)   }
        it { should delegate(:name).to('AUTHOR')   }

        context 'simple delegation' do
          include_examples 'disallow_nil', :name, :AUTHOR
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
      end
    end
  end
end
