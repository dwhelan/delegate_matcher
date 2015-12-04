shared_examples 'a delegator with a prefix' do
  it { should delegate(method_name).to(receiver).with_prefix  }
  it { should delegate(method_name).to(receiver).with_prefix(receiver.to_s)  }
  it { should delegate(method_name).to(receiver).with_prefix(receiver.to_sym)  }
end
