shared_examples 'a delegator with args' do |*args|
  it { should delegate(method_name).to(receiver).with(*args)  }
end
