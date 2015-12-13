shared_examples 'a delegator with a block' do
  it { should delegate(:name).to(receiver).with_block   }
  it { should delegate(:name).to(receiver).with_a_block }

  it { should_not delegate(:name).to(receiver).without_block   }
  it { should_not delegate(:name).to(receiver).without_a_block }

  describe 'description and failure messages' do
    before { matcher.matches? subject }

    context 'with a block' do
      let(:matcher) { delegate(:name).to(receiver).with_a_block }
      it { expect(matcher.description).to eq "delegate name to #{receiver} with a block" }
      it { expect(matcher.failure_message_when_negated).to match(/a block was passed/) }
    end

    context 'without  a block' do
      let(:matcher) { delegate(:name).to(receiver).without_a_block }
      it { expect(matcher.description).to eq "delegate name to #{receiver} without a block" }
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
