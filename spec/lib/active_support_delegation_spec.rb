require 'spec_helper'
require 'active_support/core_ext/module/delegation'

module ActiveSupportDelegation
  class Post
    attr_accessor :author

    class_variable_set(:@@authors, ['Ann Rand', 'Catherine Asaro'])
    GENRES ||= ['Fiction', 'Science Fiction']

    delegate :name,                to: :author
    delegate :name,                to: :author, prefix: true
    delegate :name,                to: :author, prefix: :writer
    delegate :name_with_nil_check, to: :author, allow_nil: true
    delegate :name_with_arg,       to: :author
    delegate :name_with_block,     to: :author
    delegate :count,               to: :@@authors
    delegate :first,               to: :GENRES
    delegate :name,                to: :class, prefix: true
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

    def name_with_block(&block)
      "#{block.call} #{name}"
    end
  end

  describe Post do
    it { should delegate(:name).to(:author) }
    it { should delegate(:name).to(:@author) }
    it { should delegate(:name_with_nil_check).to(:author).allow_nil }
    it { should delegate(:name).to(:author).with_prefix }
    it { should delegate(:name).to(:author).with_prefix(:writer) }

    it { should delegate(:name_with_arg).to(:author).with('Ms.') }
    it { should delegate(:name_with_block).to(:author).with_block }
    it { should delegate(:count).to(:@@authors)   }
    it { should delegate(:first).to(:GENRES)   }
    it { should delegate(:name).to(:class).with_prefix   }
  end
end
