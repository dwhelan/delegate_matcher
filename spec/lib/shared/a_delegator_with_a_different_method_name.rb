shared_examples 'a delegator with a different method name' do |other_name|
  it { should delegate(method_name).to(receiver).as(other_name)  }

  describe 'description' do
    let(:matcher) { delegate(method_name).to(receiver).as(other_name) }
    before { matcher.matches? subject}

    it { expect(matcher.description).to eq "delegate #{method_name} to #{receiver}.#{other_name}" }
    it { expect(matcher.failure_message).to match(/expected .* to delegate #{method_name} to #{receiver}.#{other_name}/) }
    it { expect(matcher.failure_message_when_negated).to match(/expected .* not to delegate #{method_name} to #{receiver}.#{other_name}/) }
  end
end
