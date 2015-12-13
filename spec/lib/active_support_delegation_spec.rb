require 'spec_helper'
require 'active_support/core_ext/module/delegation'

module ActiveSupportDelegation
  class Post
    attr_accessor :author

    @@authors = ['Ann Rand', 'Catherine Asaro']
    GENRES    = ['Fiction',  'Science Fiction']

    delegate :name,  to: :author, allow_nil: true
    delegate :name,  to: :author, prefix: true
    delegate :name,  to: :author, prefix: :writer
    delegate :name,  to: :class,  prefix: true
    delegate :count, to: :@@authors
    delegate :first, to: :GENRES

    def initialize
      @author = Author.new
    end
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
    it { should delegate(:name).to(:author).allow_nil }
    it { should delegate(:name).to(:author).with_prefix }
    it { should delegate(:name).to(:author).with_prefix(:writer) }
    it { should delegate(:name).to(:author).with_block }
    it { should delegate(:name).to(:author).with('Ms.') }

    it { should delegate(:name).to(:class).with_prefix   }
    it { should delegate(:count).to(:@@authors)   }
    it { should delegate(:first).to(:GENRES)   }
  end
end
