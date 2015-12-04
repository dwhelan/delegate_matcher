shared_examples 'a delegator with a block' do
  it { should delegate(method_name).to(receiver).with_block  }
  it { should delegate(method_name).to(receiver).with_a_block  }

  it { should_not delegate(method_name).to(receiver).without_block  }
  it { should_not delegate(method_name).to(receiver).without_a_block  }
end
