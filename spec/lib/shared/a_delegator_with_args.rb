shared_examples 'a delegator with args' do |*args|
  it { should delegate(:name).with(*args).to(receiver)  }

  describe 'description' do
    before { matcher.matches? subject}

    context 'with no args' do
      let(:matcher) { delegate(:name).with().to(receiver) }
      it { expect(matcher.description).to eq %(delegate #{:name}() to #{receiver}) }
    end

    context 'with args passed through' do
      let(:matcher) { delegate(:name).with('Ms.', 'Phd').to(receiver) }
      it { expect(matcher.description).to eq %(delegate #{:name}("Ms.", "Phd") to #{receiver}) }
    end

    context 'with args changed' do
      let(:matcher) { delegate(:name).with('Ms.').to(receiver).with('Mrs.') }
      it { expect(matcher.description).to eq %(delegate #{:name}("Ms.") to #{receiver}.#{:name}("Mrs.")) }
    end

      # context 'delegate(:name_with_different_arg_and_block).with("Ms.").to(:author)' do
      #   its(:description)     { should eq 'delegate name_with_different_arg_and_block("Ms.") to author' }
      #   its(:failure_message) { should match(/was called with \("Miss"\)/) }
      # end
      #
      # context 'delegate(:name_with_different_arg_and_block).with("Ms.").to(:author).with("Miss")' do
      #   its(:description)                  { should eq 'delegate name_with_different_arg_and_block("Ms.") to author.name_with_different_arg_and_block("Miss")' }
      #   its(:failure_message_when_negated) { should match(/was called with \("Miss"\)/) }
      # end
      #
      # context 'delegate(:name_with_arg2).with("The author").to(:author).as(:name_with_arg)' do
      #   its(:description) { should eq 'delegate name_with_arg2("The author") to author.name_with_arg' }
      # end
  end
end
