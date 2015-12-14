require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      module ToObject
        describe 'delegation to an object' do
          class Post
            def initialize(author)
              @author = author
            end
          end

          subject { Post.new(author) }

          let(:author)   { Author.new }
          let(:receiver) { author     }

          it 'should fail if a nil check is specified' do
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

          describe 'prefix' do
            before do
              class Post
                def author_name
                  @author.name
                end
              end
            end

            it { should delegate(:name).to(author).with_prefix('author') }
            it { should delegate(:name).to(author).with_prefix(:author)  }

            describe "description with prefix'" do
              let(:matcher) { delegate(:name).to(author).with_prefix('author') }
              before { matcher.matches? subject }

              it { expect(matcher.description).to eq "delegate author_name to #{author}.name" }
              it { expect(matcher.failure_message).to match(/expected .* to delegate author_name to #{author}.name/) }
              it { expect(matcher.failure_message_when_negated).to match(/expected .* not to delegate author_name to #{author}.name/) }
            end
          end

          describe 'default prefix' do
            before do
              class Post
                def name
                  @author.name
                end
              end
            end

            it { should delegate(:name).to(author).with_prefix }
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
