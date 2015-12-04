shared_examples 'a delegator with args and a block' do |*args|
  it_behaves_like 'a delegator with args', *args
  it_behaves_like 'a delegator with a block'

  it { should delegate(method_name).to(receiver).with(*args).with_block  }
end
