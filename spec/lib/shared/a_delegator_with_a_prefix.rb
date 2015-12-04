shared_examples 'a delegator with a prefix' do |prefix|
  it { should delegate(method_name).to(receiver).with_prefix(prefix)  }
  it { should delegate(method_name).to(receiver).with_prefix(prefix.to_sym)  }
end
