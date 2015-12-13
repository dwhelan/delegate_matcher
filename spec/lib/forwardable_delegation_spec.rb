require 'spec_helper'

module ForwardableDelegation
  class Post
    extend Forwardable

    attr_accessor :author

    def initialize
      @author = Author.new
    end

    def_delegator :author, :name
    def_delegator :author, :name, :author_name
    def_delegator :author, :name, :writer
  end

  class Author
    def name
      'Catherine Asaro'
    end
  end

  describe Post do
    let(:author) { subject.author }

    it { expect(subject.name).to eq 'Catherine Asaro' }

    it { should delegate(:name).to(author) }
    it { should delegate(:name).to(:@author) }
    it { should delegate(:name).to(:author) }
    it { should delegate(:name).to(:author).with('Ms.') }
    it { should delegate(:name).to(:author).with_block }
    it { should delegate(:name).to(:author).with_prefix }
    it { should delegate(:writer).to(:author).as(:name) }
  end
end
