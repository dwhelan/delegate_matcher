shared_examples 'a delegator with a prefix' do
  let(:prefix) { receiver.to_s.sub /@/, '' }

  it { should delegate(method_name).to(receiver).with_prefix  }
  it { should delegate(method_name).to(receiver).with_prefix(prefix)  }
  it { should delegate(method_name).to(receiver).with_prefix(prefix.to_sym)  }
end
