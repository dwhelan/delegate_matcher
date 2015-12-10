shared_examples 'a delegator with a prefix' do |prefix|
  it { should delegate(method_name).to(receiver).with_prefix(prefix)  }
  it { should delegate(method_name).to(receiver).with_prefix(prefix.to_sym)  }

  describe 'description' do
    let(:matcher) { delegate(method_name).to(receiver).with_prefix(prefix) }
    before { matcher.matches? subject}

    it { expect(matcher.description).to eq "delegate #{prefix}_#{method_name} to #{receiver}.#{method_name}" }
    it { expect(matcher.failure_message).to match(/expected .* to delegate #{prefix}_#{method_name} to #{receiver}.#{method_name}/) }
    it { expect(matcher.failure_message_when_negated).to match(/expected .* not to delegate #{prefix}_#{method_name} to #{receiver}.#{method_name}/) }
  end
end
