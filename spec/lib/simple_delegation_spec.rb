require 'spec_helper'
require 'rspec/its'

module SimpleDelegation

  class Post
    attr_accessor :author

    class_variable_set(:@@authors, ['Ann Rand', 'Catherine Asaro'])
    GENRES ||= ['Fiction', 'Science Fiction']

    def name
      author.name
    end

    def name_with_nil_check
      author.name_with_nil_check if author
    end

    def author_name
      author.name
    end

    def writer
      author.name
    end

    def name_with_arg(arg)
      author.name_with_arg(arg)
    end

    def name_with_different_arg(_arg)
      author.name_with_different_arg('Miss')
    end

    def name_with_block(&block)
      author.name_with_block(&block)
    end

    def class_name
      self.class.class_name
    end

    def count
      self.class.class_variable_get(:@@authors).count
    end

    def first
      GENRES.first
    end
  end

  class Author
    def name
      'Catherine Asaro'
    end

    def name_with_nil_check
      name
    end

    def name_with_arg(arg)
      "#{arg} #{name}"
    end

    def name_with_different_arg(arg)
      "#{arg} #{name}"
    end

    def name_with_block(&block)
      "#{block.call} #{name}"
    end
  end

  describe Post do
    it { should delegate(:name).to(:author) }
    it { should delegate(:name_with_nil_check).to(:author).allow_nil }
    it { should delegate(:name).to(:author).with_prefix }
    it { should delegate(:writer).to(:author).as(:name) }
    it { should delegate(:name_with_arg).to(:author).with('Ms.') }
    it { should delegate(:name_with_different_arg).with('Ms').to(:author).with('Miss') }
    it { should delegate(:name_with_block).to(:author).with_block }
    it { should delegate(:count).to(:@@authors)   }
    it { should delegate(:first).to(:GENRES)   }
  end
end
