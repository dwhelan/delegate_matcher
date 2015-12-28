require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      shared_context 'Post delegation' do
        subject { klass.new }

        let(:klass) do
          Class.new do
            include PostMethods

            def initialize
              @author = Author.new
            end

            def name
              @author.name
            end
          end
        end

        before do
          klass.class_eval method_definition
          matcher.matches? subject
        end

        def method_definition
          klass = self.class
          while klass != Object
            return klass.description if klass.respond_to?(:description) && klass.description =~ /def \w*name/
            klass = klass.parent
          end

          return '# Could not find "def \w*name..." method definition'
        end

        let(:matcher) { delegate(:name).to(:@author) }
      end
    end
  end
end
