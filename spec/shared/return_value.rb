shared_examples 'a delegator with a different return value' do |actual_return_value|
  it { should     delegate(:name).to(receiver).without_return  }
  it { should_not delegate(:name).to(receiver) }

  describe 'description' do
    let(:matcher) { delegate(:name).to(receiver).without_return }
    before { matcher.matches? subject }

    it { expect(matcher.description).to eq %(delegate name to "#{receiver}" without using delegate return value) }
    it { expect(matcher.failure_message_when_negated).to match(/expected .* not to delegate name to "#{receiver}" without using delegate return value/) }
  end

  describe 'failure message' do
    let(:matcher) { delegate(:name).to(receiver) }
    before { matcher.matches? subject }

    it { expect(matcher.failure_message).to match(/a value of "#{actual_return_value}" was returned instead of/) }
  end
end

shared_examples 'a delegator with a specified return value' do |return_value|
  it { should     delegate(:name).to(receiver).and_return return_value }
  it { should_not delegate(:name).to(receiver) }

  describe 'description' do
    let(:matcher) { delegate(:name).to(receiver).and_return return_value }
    before { matcher.matches? subject }

    it { expect(matcher.description).to eq %(delegate name to "#{receiver}" and return "#{return_value}") }
    it { expect(matcher.failure_message_when_negated).to match(/expected .* not to delegate name to "#{receiver}" and return "#{return_value}/) }
  end

  describe 'failure message' do
    let(:matcher) { delegate(:name).to(receiver).and_return 'Isaac Asimov' }
    before { matcher.matches? subject }

    it { expect(matcher.failure_message).to match(/a value of "#{return_value}" was returned instead of "Isaac Asimov"/) }
  end
end
