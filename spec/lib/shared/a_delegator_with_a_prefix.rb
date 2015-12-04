shared_examples 'a delegator with a prefix' do |method, delegate|
  it { should delegate(method).to(delegate).with_prefix  }
  it { should delegate(method).to(delegate).with_prefix(delegate.to_s)  }
  it { should delegate(method).to(delegate).with_prefix(delegate.to_sym)  }
end
