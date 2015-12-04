shared_examples 'a delegator with args and a block' do |method, delegate, *args|
  it { should delegate(method).to(delegate).with(*args).with_block  }
end
