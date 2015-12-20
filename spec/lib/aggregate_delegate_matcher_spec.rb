module RSpec
  module Matchers
    module DelegateMatcher
      module Composite
        describe 'delegation to a composite' do
          class Post
            include PostMethods

            def authors
              @authors ||= [Author.new('Catherine Asaro'), Author.new('Isaac Asimov')]
            end

            def name
              @authors.map(&:name)
            end
          end

          subject { Post.new }

          let(:receiver) { subject.autho }

          it '' do
            expect(subject).to delegate(:name).to(*subject.authors)
          end
        end
      end
    end
  end
end

