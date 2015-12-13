shared_examples 'a delegator with a nil check' do
  it { should     delegate(:name).to(receiver).allow_nil        }
  it { should     delegate(:name).to(receiver).allow_nil(true)  }
  it { should_not delegate(:name).to(receiver).allow_nil(false) }

  describe 'description' do
    before { matcher.matches? subject }

    context 'with allow nil at default' do
      let(:matcher) { delegate(:name).to(receiver).allow_nil }
      it { expect(matcher.description).to eq %(delegate name to #{receiver} with nil allowed) }
      it { expect(matcher.failure_message_when_negated).to match(/#{receiver} was allowed to be nil/) }
    end

    context 'with allow nil true' do
      let(:matcher) { delegate(:name).to(receiver).allow_nil(true) }
      it { expect(matcher.description).to eq %(delegate name to #{receiver} with nil allowed) }
      it { expect(matcher.failure_message_when_negated).to match(/#{receiver} was allowed to be nil/) }
    end

    context 'with allow nil false' do
      let(:matcher) { delegate(:name).to(receiver).allow_nil(false) }
      it { expect(matcher.description).to eq %(delegate name to #{receiver} with nil not allowed) }
      it { expect(matcher.failure_message).to match(/#{receiver} was allowed to be nil/) }
    end
  end
end

shared_examples 'a delegator without a nil check' do
  it { should     delegate(:name).to(receiver).allow_nil(false)  }
  it { should_not delegate(:name).to(receiver).allow_nil(true)  }
  it { should_not delegate(:name).to(receiver).allow_nil  }

  describe 'description' do
    before { matcher.matches? subject }

    context 'with allow nil at default' do
      let(:matcher) { delegate(:name).to(receiver).allow_nil }
      it { expect(matcher.failure_message).to match(/#{receiver} was not allowed to be nil/) }
    end

    context 'with allow nil true' do
      let(:matcher) { delegate(:name).to(receiver).allow_nil(true) }
      it { expect(matcher.failure_message).to match(/#{receiver} was not allowed to be nil/) }
    end

    context 'with allow nil false' do
      let(:matcher) { delegate(:name).to(receiver).allow_nil(false) }
      it { expect(matcher.failure_message_when_negated).to match(/#{receiver} was not allowed to be nil/) }
    end
  end
end
