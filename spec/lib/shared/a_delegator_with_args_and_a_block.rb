shared_examples 'a delegator with args and a block' do |method, delegate, *args|
  it_behaves_like 'a delegator with args',    method, delegate, *args
  it_behaves_like 'a delegator with a block', method, delegate

  it { should delegate(method).to(delegate).with(*args).with_block  }
end
