shared_examples 'a delegator with args' do
  it { should delegate(:name).with('Ms.').to(receiver)  }
  it { should delegate(:name).with('Ms.').to(receiver).with(anything) }
  it { should delegate(:name).with('Ms.').to(receiver).with(any_args) }
  it { should delegate(:name).with().to(receiver).with(no_args) }

  describe 'description and failure messages' do
    before { matcher.matches? subject }

    context 'with no args' do
      let(:matcher) { delegate(:name).with.to(receiver) }
      it { expect(matcher.description).to eq %(delegate name() to "#{receiver}") }
    end

    context 'with args passed through' do
      let(:matcher) { delegate(:name).with('Ms.').to(receiver) }
      it { expect(matcher.description).to eq %(delegate name("Ms.") to "#{receiver}") }
      it { expect(matcher.failure_message_when_negated).to match(/was called with \("Ms."\)/) }
    end

    context 'with args changed' do
      let(:matcher) { delegate(:name).with('Ms.').to(receiver).with('Mrs.') }
      it { expect(matcher.description).to eq %(delegate name("Ms.") to "#{receiver}".name("Mrs.")) }
      it { expect(matcher.failure_message).to match(/was called with \("Ms."\)/) }
    end

    context 'with anything' do
      let(:matcher) { delegate(:name).with('Ms.').to(receiver).with(anything) }
      it { expect(matcher.description).to eq %(delegate name("Ms.") to "#{receiver}".name(anything)) }
    end

    context 'with any args' do
      let(:matcher) { delegate(:name).with('Ms.').to(receiver).with(any_args) }
      it { expect(matcher.description).to eq %(delegate name("Ms.") to "#{receiver}".name(*(any args))) }
    end
  end
end
