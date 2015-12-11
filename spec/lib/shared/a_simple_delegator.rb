shared_examples 'a simple delegator' do
  it { should delegate(:name).to(receiver)      }
  it { should delegate(:name.to_s).to(receiver) }

  it { should_not delegate(:to_s).to(receiver) }

  include_examples 'a delegator without a block'

  describe 'description' do
    let(:matcher) { delegate(:name).to(receiver) }
    before { matcher.matches? subject}

    it { expect(matcher.description).to eq "delegate #{:name} to #{receiver}" }
    it { expect(matcher.failure_message).to match(/expected .* to delegate #{:name} to #{receiver}/) }
    it { expect(matcher.failure_message_when_negated).to match(/expected .* not to delegate #{:name} to #{receiver}/) }
  end
end
