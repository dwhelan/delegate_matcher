require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher

      describe 'delegation to an instance variable' do
        let(:klass) do
          Class.new do
            include PostMethods

            def initialize
              @author = Author.new
            end

            def name
              @author.name
            end

            def name_allow_nil
              @author.name if @author
            end
          end
        end

        subject { klass.new }

        let(:receiver) { :@author }

        it_behaves_like 'a basic delegator'
        it_behaves_like 'a delegator without a nil check'
        it_behaves_like 'a delegator with a nil check2'
      end
        # class Post
        #   include PostMethods
        #
        #   def initialize
        #     @author = Author.new
        #     @authors ||= [@author]
        #   end
        # end
        #
        # subject { Post.new }
        #
        # [:@author, '@author'].each do |instance_variable|
        #   let(:receiver) { instance_variable }
        #
        #   it_behaves_like 'a basic delegator' do
        #     before do
        #       class Post
        #         def name
        #           @author.name
        #         end
        #       end
        #     end
        #     include_examples 'a delegator without a nil check'
        #   end
        #
        #   it_behaves_like 'a delegator with a nil check' do
        #     before do
        #       class Post
        #         def name
        #           @author.name if @author
        #         end
        #       end
        #     end
        #   end
        #
        #   it_behaves_like 'a delegator with args and a block' do
        #     before do
        #       class Post
        #         def name(*args, &block)
        #           @author.name(*args, &block)
        #         end
        #       end
        #     end
        #   end
        #
        #   it_behaves_like 'a delegator with its own block' do
        #     before do
        #       class Post
        #         # rubocop:disable Style/SymbolProc
        #         def tainted?
        #           @authors.all? { |a| a.tainted? }
        #         end
        #       end
        #     end
        #   end
        #
        #   it_behaves_like 'a delegator with a different method name', :other_name do
        #     before do
        #       class Post
        #         def name
        #           @author.other_name
        #         end
        #       end
        #     end
        #   end
        #
        #   it_behaves_like 'a delegator with a prefix', 'author' do
        #     before do
        #       class Post
        #         def author_name
        #           @author.name
        #         end
        #       end
        #     end
        #     it { should delegate(:name).to(:@author).with_prefix  }
        #   end
        #
        #   it_behaves_like 'a delegator with a different return value', 'Ann Rand' do
        #     before do
        #       class Post
        #         def name
        #           @author.name
        #           'Ann Rand'
        #         end
        #       end
        #     end
        #   end
        # end
    end
  end
end
