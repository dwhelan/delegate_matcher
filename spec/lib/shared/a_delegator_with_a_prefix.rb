shared_examples 'a delegator with a prefix' do |prefix|
  it { should delegate(method_name).to(receiver).with_prefix  }
  it { should delegate(method_name).to(receiver).with_prefix(prefix)  }
  it { should delegate(method_name).to(receiver).with_prefix(prefix.to_sym)  }

  [prefix, nil].each do |test_prefix|
    describe "description with prefix '#{test_prefix}'" do
      let(:matcher) { delegate(method_name).to(receiver).with_prefix(test_prefix) }
      before { matcher.matches? subject}

      it { expect(matcher.description).to eq "delegate #{prefix}_#{method_name} to #{receiver}.#{method_name}" }
      it { expect(matcher.failure_message).to match(/expected .* to delegate #{prefix}_#{method_name} to #{receiver}.#{method_name}/) }
      it { expect(matcher.failure_message_when_negated).to match(/expected .* not to delegate #{prefix}_#{method_name} to #{receiver}.#{method_name}/) }
    end
  end
end
