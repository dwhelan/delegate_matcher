# noinspection RubyResolve

require 'spec_helper'

describe 'DelegateTo matcher' do
  # :nocov:
  let(:post) do
    Class.new do
      attr_accessor :author

      class_variable_set(:@@authors, ['Ann Rand', 'Catherine Asaro'])
      GENRES ||= ['Fiction', 'Science Fiction']

      def name
        author.name
      end

      def name_with_bad_return
        author.name_with_bad_return
        'Ann Rand'
      end

      def name_with_nil_check
        author.name_with_nil_check if author
      end

      def name_with_nil_check_and_bad_return
        author.name_with_nil_check_and_bad_return if author
        'Ann Rand'
      end

      def author_name
        author.name
      end

      def writer
        author.name
      end

      def writer_name
        author.name
      end

      def name_with_arg(arg)
        author.name_with_arg(arg)
      end

      def name_with_arg2(arg)
        author.name_with_arg(arg)
      end

      def name_with_default_arg(arg = 'The author')
        author.name_with_default_arg(arg)
      end

      def name_with_multiple_args(arg1, arg2)
        author.name_with_multiple_args(arg1, arg2)
      end

      def name_with_optional_arg(*address)
        author.name_with_optional_arg(*address)
      end

      def name_with_block(&block)
        author.name_with_block(&block)
      end

      def name_with_different_block(&_block)
        author.name_with_different_block(&proc {})
      end

      def name_with_arg_and_block(arg, &block)
        author.name_with_arg_and_block(arg, &block)
      end

      def name_with_different_arg_and_block(_arg, &_block)
        author.name_with_different_arg_and_block('Miss', &proc {})
      end

      def name_without_return
        author.name_without_return
        'should not be checked'
      end

      def age
        60
      end

      def class_name
        self.class.name
      end

      def count
        self.class.class_variable_get(:@@authors).count
      end

      def first
        GENRES.first
      end

      def inspect
        'post'
      end
    end.new
  end

  let(:author) do
    Class.new do
      def name
        'Catherine Asaro'
      end

      def name_with_bad_return
        name
      end

      def name_with_nil_check
        name
      end

      def name_with_nil_check_and_bad_return
        'Ann Rand'
      end

      def name_with_arg(arg)
        "#{arg} #{name}"
      end

      def name_with_default_arg(arg = 'The author')
        "#{arg} #{name}"
      end

      def name_with_multiple_args(arg1, arg2)
        "#{arg1} #{arg2} #{name}"
      end

      def name_with_optional_arg(*args)
        "#{[args, name].flatten.join(' ')}"
      end

      def name_with_block(&block)
        "#{block.call} #{name}"
      end

      def name_with_arg_and_block(arg, &block)
        "#{arg} #{block.call} #{name}"
      end

      def name_with_different_arg_and_block(arg, &block)
        "#{arg} #{block.call} #{name}"
      end

      def name_without_return
        name
      end

      def to_s
        'author'
      end

      def inspect
        'author'
      end
    end.new
  end
  # :nocov:

  subject { post }
  before  { post.author = author }

  describe 'test support' do
    its(:name)                  { should eq 'Catherine Asaro' }
    its(:name_with_nil_check)   { should eq 'Catherine Asaro' }
    its(:name_with_default_arg) { should eq 'The author Catherine Asaro' }
    its(:author_name)           { should eq 'Catherine Asaro' }
    its(:writer)                { should eq 'Catherine Asaro' }
    its(:writer_name)           { should eq 'Catherine Asaro' }
    its(:age)                   { should eq 60                }
    its(:count)                 { should eq 2                 }
    its(:first)                 { should eq 'Fiction'         }
    its(:class_name)            { should be_nil         }

    it { expect(post.name_with_arg('The author')).to                 eq 'The author Catherine Asaro' }
    it { expect(post.name_with_arg2('The author')).to                eq 'The author Catherine Asaro' }
    it { expect(post.name_with_default_arg('The famous')).to         eq 'The famous Catherine Asaro' }
    it { expect(post.name_with_multiple_args('The', 'author')).to    eq 'The author Catherine Asaro' }
    it { expect(post.name_with_optional_arg).to                      eq 'Catherine Asaro' }
    it { expect(post.name_with_optional_arg('The author')).to        eq 'The author Catherine Asaro' }
    it { expect(post.name_with_optional_arg('The', 'author')).to     eq 'The author Catherine Asaro' }
    it { expect(post.name_with_block { 'The author' }).to            eq 'The author Catherine Asaro' }
    it { expect(post.name_with_arg_and_block('The') { 'author' }).to eq 'The author Catherine Asaro' }

    context 'with nil author' do
      before { post.author = nil }

      it { expect(post.name_with_nil_check).to be_nil }
      it { expect(post.name_with_nil_check_and_bad_return).to eq 'Ann Rand' }
    end
  end

  describe 'delegation to instance method' do
    it { should     delegate(:name).to(:author)   }
    it { should     delegate(:writer).to(:author).as(:name) }
    it { should_not delegate(:age).to(:author) }
  end

  describe 'delegation to class method' do
    it { should delegate(:class_name).to(:class).as(:name)   }
  end

  describe 'delegation to instance variable' do
    it { should     delegate(:name).to(:@author)   }
    it { should     delegate(:writer).to(:@author).as(:name) }
    it { should_not delegate(:age).to(:@author) }
  end

  describe 'delegation to class variable' do
    it { should delegate(:count).to(:@@authors)   }
  end

  describe 'delegation to constant' do
    it { should delegate(:first).to(:GENRES)   }
  end

  describe 'delegation to object' do
    it { should delegate(:name).to(author) }
    it { should delegate(:writer).to(author).as(:name) }

    it { should_not delegate(:age).to(author) }
  end

  describe 'return value' do
    it { should_not delegate(:name_with_bad_return).to(:author)   }
  end

  describe 'with_prefix' do
    it { should delegate(:name).to(:author).with_prefix           }
    it { should delegate(:name).to(:author).with_prefix(:writer)  }
    it { should delegate(:name).to(:author).with_prefix('writer') }
  end

  describe 'allow_nil' do
    context 'when delegator checks that delegate is nil' do
      before { post.author = nil }

      it { should     delegate(:name_with_nil_check).to(:author).allow_nil(true)  }
      it { should     delegate(:name_with_nil_check).to(:author).allow_nil        }

      it { should_not delegate(:name_with_nil_check).to(:author).allow_nil(false) }
      it { should_not delegate(:name_with_nil_check_and_bad_return).to(:author).allow_nil }
    end

    context 'when delegator does not check that delegate is nil' do
      it { should     delegate(:name).to(:author).allow_nil(false) }
      it { should_not delegate(:name).to(:author).allow_nil(true)  }
      it { should_not delegate(:name).to(:author).allow_nil        }
    end
  end

  describe 'with arguments' do
    it { should delegate(:name_with_arg).with('Ms.').to(:author)                                     }
    it { should delegate(:name_with_arg).with('Ms.').to(:author).with('Ms.')                                     }
    it { should delegate(:name_with_multiple_args).with('The', 'author').to(:author)                    }
    it { should delegate(:name_with_optional_arg).with('The author').to(:author)                  }
    it { should delegate(:name_with_optional_arg).with('The', 'author').to(:author)   }
    it { should delegate(:name_with_default_arg).to(:author)   }
    it { should delegate(:name_with_default_arg).with('The author').to(:author)   }

    it { should     delegate(:name_with_different_arg_and_block).with('Ms.').to(:author).with('Miss') }
    it { should_not delegate(:name_with_different_arg_and_block).with('Ms.').to(:author).with('Ms.')  }
  end

  describe 'with a block' do
    it { should delegate(:name_with_block).to(:author).with_a_block }
    it { should delegate(:name_with_block).to(:author).with_block   }

    it { should_not delegate(:name).to(:author).with_a_block }
    it { should_not delegate(:name).to(:author).with_block   }
    it { should_not delegate(:name_with_different_block).to(:author).with_a_block }
  end

  describe 'without a block' do
    it { should delegate(:name).to(:author).without_a_block }

    it { should_not delegate(:name_with_block).to(:author).without_block   }
    it { should_not delegate(:name_with_block).to(:author).without_a_block }
    it { should_not delegate(:name_with_different_block).to(:author).without_a_block }
  end

  describe 'arguments and blocks' do
    it { should delegate(:name_with_arg_and_block).to(:author).with(true).with_block }
  end

  describe 'without_return' do
    it { should delegate(:name_without_return).to(:author).without_return }
  end

  describe 'should raise error' do
    it 'with "to" not specified' do
      expect { should delegate(:name) }.to raise_error do |error|
        expect(error.message).to match(/need to provide a "to"/)
      end
    end

    it 'with an invalid "to"' do
      expect { should delegate(:name).to(:invalid_delegate) }.to raise_error do |error|
        expect(error.message).to match(/does not respond to invalid_delegate/)
      end
    end

    it 'with delegate that requires arguments' do
      expect { should delegate(:name).to(:name_with_arg) }.to raise_error do |error|
        expect(error.message).to match(/name_with_arg method expects parameters/)
      end
    end

    it 'with delegate method argument mismatch' do
      expect { should delegate(:name_with_arg).to(:author) }.to raise_error do |error|
        expect(error.message).to match(/wrong number of arguments/)
      end
    end

    it 'with delegation to an object with "allow_nil" expectations' do
      expect { should delegate(:name).to(author).allow_nil }.to raise_error do |error|
        expect(error.message).to match(/cannot verify "allow_nil" expectations when delegating to an object/)
      end
    end

    it 'with delegation to a constant with "allow_nil" expectations' do
      expect { should should delegate(:first).to(:GENRES).allow_nil }.to raise_error do |error|
        expect(error.message).to match(/cannot verify "allow_nil" expectations when delegating to a constant/)
      end
    end
  end

  describe 'description' do
    let(:matcher) { self.class.parent_groups[1].description }
    subject       { eval matcher }
    before        { subject.matches? post }

    context 'delegate(:name).to(:author)' do
      its(:description)                  { should eq 'delegate name to author' }
      its(:failure_message_when_negated) { should match(/expected .* not to delegate name to author/) }
    end

    context 'delegate(:age).to(author)' do
      its(:description)     { should eq 'delegate age to author' }
      its(:failure_message) { should match(/expected .* to delegate age to author/) }
    end

    context 'delegate(:writer).to(:author).as(:name)' do
      its(:description) { should eq 'delegate writer to author.name' }
    end

    context 'delegate(:name).to(:@author)' do
      its(:description) { should eq 'delegate name to @author' }
    end

    context 'delegate(:name).to(:author).with_prefix' do
      its(:description) { should eq 'delegate author_name to author.name' }
    end

    context 'delegate(:name).to(:author).with_prefix("writer")' do
      its(:description) { should eq 'delegate writer_name to author.name' }
    end

    context 'delegate(:writer).to(:author).as("name")' do
      its(:description) { should eq 'delegate writer to author.name' }
    end

    context 'delegate(:name_with_bad_return).to(:author)' do
      its(:description)     { should eq 'delegate name_with_bad_return to author' }
      its(:failure_message) { should match(/a return value of "Ann Rand" was returned instead of the delegate return value/) }
    end

    context 'with allow_nil true' do
      context 'delegate(:name).to(:author).allow_nil' do
        its(:description)     { should eq 'delegate name to author with nil allowed' }
        its(:failure_message) { should match(/author was not allowed to be nil/) }
      end

      context 'delegate(:name).to(:author).allow_nil(true)' do
        its(:description)     { should eq 'delegate name to author with nil allowed' }
        its(:failure_message) { should match(/author was not allowed to be nil/) }
      end

      context 'delegate(:name_with_nil_check_and_bad_return).to(:author).allow_nil' do
        its(:failure_message) { should match(/did not return nil/) }
      end

      context 'delegate(:name_with_nil_check).to(:author).allow_nil' do
        its(:failure_message_when_negated) { should match(/author was allowed to be nil/) }
      end
    end

    context 'with allow_nil false' do
      context 'delegate(:name_with_nil_check).to(:author).allow_nil(false)' do
        its(:description)     { should eq 'delegate name_with_nil_check to author with nil not allowed' }
        its(:failure_message) { should match(/author was allowed to be nil/) }
      end

      context 'delegate(:name).to(:author).allow_nil(false)' do
        its(:failure_message_when_negated) { should match(/author was not allowed to be nil/) }
      end
    end

    context 'with arguments' do
      context 'delegate(:name_with_multiple_args).with("Ms.", "Phd").to(:author)' do
        its(:description) { should eq 'delegate name_with_multiple_args("Ms.", "Phd") to author' }
      end

      context 'delegate(:name_with_different_arg_and_block).with("Ms.").to(:author)' do
        its(:description)     { should eq 'delegate name_with_different_arg_and_block("Ms.") to author' }
        its(:failure_message) { should match(/was called with \("Miss"\)/) }
      end

      context 'delegate(:name_with_different_arg_and_block).with("Ms.").to(:author).with("Miss")' do
        its(:description)                  { should eq 'delegate name_with_different_arg_and_block("Ms.") to author.name_with_different_arg_and_block("Miss")' }
        its(:failure_message_when_negated) { should match(/was called with \("Miss"\)/) }
      end

      context 'delegate(:name_with_arg2).with("The author").to(:author).as(:name_with_arg)' do
        its(:description) { should eq 'delegate name_with_arg2("The author") to author.name_with_arg' }
      end
    end

    context 'with a block' do
      context 'delegate(:name).to(:author).with_a_block' do
        its(:description)     { should eq 'delegate name to author with a block' }
        its(:failure_message) { should match(/a block was not passed/) }
      end

      context 'delegate(:name_with_different_block).to(:author).with_a_block' do
        its(:failure_message) { should match(/a different block .+ was passed/) }
      end

      context 'delegate(:name_with_block).to(:author).with_a_block' do
        its(:failure_message_when_negated) { should match(/a block was passed/) }
      end

      context 'and arguments' do
        context 'delegate(:name_with_different_arg_and_block).with("Ms.").to(:author).with_a_block' do
          its(:description)     { should eq 'delegate name_with_different_arg_and_block("Ms.") to author with a block' }
          its(:failure_message) { should match(/was called with \("Miss"\) /) }
          its(:failure_message) { should match(/and a different block .+ was passed/) }
        end

        context 'delegate(:name_with_arg_and_block).to(:author).with(true).with_a_block' do
          its(:failure_message_when_negated) { should match(/was called with \(true\) /) }
          its(:failure_message_when_negated) { should match(/and a block was passed/) }
        end
      end
    end

    context 'without a block' do
      context 'delegate(:name_with_block).to(:author).without_a_block' do
        its(:description)     { should eq 'delegate name_with_block to author without a block' }
        its(:failure_message) { should match(/a block was passed/) }
      end

      context 'delegate(:name_with_different_block).to(:author).without_a_block' do
        its(:failure_message) { should match(/a block was passed/) }
      end

      context 'delegate(:name).to(:author).without_a_block' do
        its(:failure_message_when_negated) { should match(/a block was not passed/) }
      end

      context 'and arguments' do
        context 'delegate(:name_with_different_arg_and_block).to(:author).with("Miss").without_a_block' do
          its(:description)     { should eq 'delegate name_with_different_arg_and_block("Miss") to author without a block' }
          its(:failure_message) { should match(/a block was passed/) }
        end

        context 'delegate(:name_with_arg).to(:author).with("Miss").without_a_block' do
          its(:failure_message_when_negated) { should match(/was called with \("Miss"\) /) }
          its(:failure_message_when_negated) { should match(/and a block was not passed/) }
        end
      end
    end
  end
end
