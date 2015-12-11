shared_examples 'a delegator with a block' do
  it { should delegate(:name).to(receiver).with_block  }
  it { should delegate(:name).to(receiver).with_a_block  }

  it { should_not delegate(:name).to(receiver).without_block  }
  it { should_not delegate(:name).to(receiver).without_a_block  }

  describe 'description' do
    let(:matcher) { delegate(:name).to(receiver).without_a_block }
    before { matcher.matches? subject}

    it { expect(matcher.description).to eq "delegate #{:name} to #{receiver} without a block" }
    it { expect(matcher.failure_message).to match(/a block was passed/) }
  end
end
