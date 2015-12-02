# noinspection RubyResolve

require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher

      class Post
        GENRES ||= ['Fiction', 'Science Fiction']
      end

      describe 'DelegateTo matcher with constants' do
        subject { Post.new }

        context 'without nil check' do
          before do
            class Post
              def first
                GENRES.first
              end
            end
          end

          it { should delegate(:first).to(:GENRES)   }

          include_examples 'disallow_nil', :first, :GENRES
        end

        context 'with nil check' do
          before do
            class Post
              def first
                GENRES.first if GENRES
              end
            end
          end

          include_examples 'allow_nil', :first, :GENRES
        end
      end
    end
  end
end

