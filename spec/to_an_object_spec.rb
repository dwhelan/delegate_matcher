require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      describe 'delegation to an object' do
        let(:klass) do
          Class.new do
            include PostMethods

            def initialize(author)
              @author = author
            end

            def name
              @author.name
            end
          end
        end

        subject { klass.new(author) }

        let(:author)   { Author.new }
        let(:receiver) { author     }

        it_behaves_like 'a basic delegator'

        it do
          expect { should delegate(:name).to(author).allow_nil }.to \
            raise_error RuntimeError, 'cannot verify "allow_nil" expectations when delegating to an object'
        end

        it do
          expect { should delegate(:name).to(author).allow_nil(true) }.to \
            raise_error RuntimeError, 'cannot verify "allow_nil" expectations when delegating to an object'
        end

        it do
          expect { should delegate(:name).to(author).allow_nil(false) }.to \
            raise_error RuntimeError, 'cannot verify "allow_nil" expectations when delegating to an object'
        end

        it 'prefex should be ignored' do
          should delegate(:name).to(author).with_prefix
        end
      end
    end
  end
end
