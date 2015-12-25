shared_examples 'a delegator with a block' do
  it { should delegate(:name).to(receiver).with_block   }
  it { should delegate(:name).to(receiver).with_a_block }

  it { should_not delegate(:name).to(receiver).without_block   }
  it { should_not delegate(:name).to(receiver).without_a_block }

  describe 'description and failure messages' do
    before { matcher.matches? subject }

    context 'with a block' do
      let(:matcher) { delegate(:name).to(receiver).with_a_block }
      it { expect(matcher.description).to eq %(delegate name to "#{receiver}" with a block) }
      it { expect(matcher.failure_message_when_negated).to match(/a block was passed/) }
    end

    context 'without a block' do
      let(:matcher) { delegate(:name).to(receiver).without_a_block }
      it { expect(matcher.description).to eq %(delegate name to "#{receiver}" without a block) }
      it { expect(matcher.failure_message).to match(/a block was passed/) }
    end
  end
end

shared_examples 'a delegator with its own block' do
  # rubocop:disable Style/SymbolProc
  it { should     delegate(:tainted?).to(:@authors).as(:all?).with_block { |a| a.tainted? } }
  it { should_not delegate(:tainted?).to(:@authors).as(:all?).with_block { |a| a.to_s } }

  describe 'description' do
    before { matcher.matches? subject }

    context 'with a block' do
      let(:matcher) { delegate(:tainted?).to(:@authors).as(:all?).with_block { |a| a.tainted? } }
      it { expect(matcher.description).to eq %(delegate tainted? to "@authors".all? with block "proc { |a| a.tainted? }") }
      it { expect(matcher.failure_message_when_negated).to match(/a block was passed/) }
    end

    context 'with a different block' do
      let(:matcher) { delegate(:tainted?).to(:@authors).as(:all?).with_block { |a| a.to_s } }
      it { expect(matcher.failure_message).to match(/a different block "proc { |a| a.tainted? }" was passed/) }
    end

    context 'without a block' do
      let(:matcher) { delegate(:tainted?).to(:@authors).as(:all?).without_block }
      it { expect(matcher.failure_message).to match(/a block was passed/) }
    end
  end
end

shared_examples 'a delegator without a block' do
  it { should delegate(:name).to(receiver).without_block  }
  it { should delegate(:name).to(receiver).without_a_block  }

  it { should_not delegate(:name).to(receiver).with_block  }
  it { should_not delegate(:name).to(receiver).with_a_block  }

  describe 'failure messages' do
    before { matcher.matches? subject }

    context 'with a block' do
      let(:matcher) { delegate(:name).to(receiver).with_a_block }
      it { expect(matcher.failure_message).to match(/a block was not passed/) }
    end

    context 'without  a block' do
      let(:matcher) { delegate(:name).to(receiver).without_a_block }
      it { expect(matcher.failure_message_when_negated).to match(/a block was not passed/) }
    end
  end
end