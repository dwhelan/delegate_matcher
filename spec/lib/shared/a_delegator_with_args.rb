shared_examples 'a delegator with args' do |method, delegate, *args|
  it { should delegate(method).to(delegate).with(*args)  }
end
