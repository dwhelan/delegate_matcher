shared_examples 'a delegator with args' do |*args|
  it { should delegate(:name).with(*args).to(receiver)  }

  describe 'description' do
    before { matcher.matches? subject}

    context 'with no args' do
      let(:matcher) { delegate(:name).with().to(receiver) }
      it { expect(matcher.description).to eq %(delegate #{:name}() to #{receiver}) }
    end

    context 'with args passed through' do
      let(:matcher) { delegate(:name).with('Ms.').to(receiver) }
      it { expect(matcher.description).to eq %(delegate #{:name}("Ms.") to #{receiver}) }
      fit { expect(matcher.failure_message_when_negated).to match /was called with \("Ms."\)/ }
    end

    context 'with args changed' do
      let(:matcher) { delegate(:name).with('Ms.').to(receiver).with('Mrs.') }
      it { expect(matcher.description).to eq %(delegate #{:name}("Ms.") to #{receiver}.#{:name}("Mrs.")) }
      it { expect(matcher.failure_message).to match /was called with \("Ms."\)/ }
    end
  end
end
