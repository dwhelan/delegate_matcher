require 'spec_helper'
require 'rspec/its'

module ForwardableDelegation
  class Post
    extend Forwardable

    attr_accessor :author

    def_delegator :author, :name
    def_delegator :author, :name, :writer
    def_delegator :author, :name_with_arg
    def_delegator :author, :name_with_block
  end

  class Author
    def name
      'Catherine Asaro'
    end

    def name_with_arg(arg)
      "#{arg} #{name}"
    end

    def name_with_block(&block)
      "#{block.call} #{name}"
    end
  end

  describe Post do
    it { should delegate(:name).to(:author) }
    it { should delegate(:name).to(:@author) }
    it { should delegate(:writer).to(:author).as(:name) }
    it { should delegate(:name_with_arg).to(:author).with('Ms.') }
    it { should delegate(:name_with_block).to(:author).with_block }
  end
end
