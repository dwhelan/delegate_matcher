require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      module Composite
        describe 'delegation to multiple targets' do
          class Post
            include PostMethods

            attr_accessor :authors, :catherine_asaro, :isaac_asimov

            def initialize
              self.catherine_asaro = Author.new('Catherine Asaro')
              self.isaac_asimov    = Author.new('Isaac Asimov')
              self.authors         = [catherine_asaro, isaac_asimov]
            end

            def name
              authors.map(&:name)
            end
          end

          subject { Post.new }

          it { should delegate(:name).to(*subject.authors) }
          it { should delegate(:name).to(subject.catherine_asaro, subject.isaac_asimov) }
          it { should delegate(:name).to(:catherine_asaro, :isaac_asimov) }
          it { should delegate(:name).to(:@catherine_asaro, :@isaac_asimov) }
        end
      end
    end
  end
end
