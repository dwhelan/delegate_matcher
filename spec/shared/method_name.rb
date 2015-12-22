shared_examples 'a delegator with a different method name' do |other_name|
  it { should delegate(:name).to(receiver).as(other_name)  }

  describe 'description and failure messages' do
    let(:matcher) { delegate(:name).to(receiver).as(other_name) }
    before { matcher.matches? subject }

    it { expect(matcher.description).to eq %(delegate name to "#{receiver}".#{other_name}) }
    it { expect(matcher.failure_message).to match(/expected .* to delegate name to "#{receiver}".#{other_name}/) }
    it { expect(matcher.failure_message_when_negated).to match(/expected .* not to delegate name to "#{receiver}".#{other_name}/) }
  end
end
