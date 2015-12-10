shared_examples 'a simple delegator' do
  it { should delegate(method_name).to(receiver)      }
  it { should delegate(method_name.to_s).to(receiver) }

  it { should_not delegate(:to_s).to(receiver) }

  include_examples 'a delegator without a block'

  describe 'description' do
    let(:matcher) { delegate(method_name).to(receiver) }
    before { matcher.matches? subject}

    it { expect(matcher.description).to eq "delegate #{method_name} to #{receiver}" }
    it { expect(matcher.failure_message).to match(/expected .* to delegate #{method_name} to #{receiver}/) }
    it { expect(matcher.failure_message_when_negated).to match(/expected .* not to delegate #{method_name} to #{receiver}/) }
  end
end
