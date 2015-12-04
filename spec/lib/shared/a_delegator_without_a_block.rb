shared_examples 'a delegator without a block' do |method, delegate|
  it { should delegate(method).to(delegate).without_block  }
  it { should delegate(method).to(delegate).without_a_block  }

  it { should_not delegate(method).to(delegate).with_block  }
  it { should_not delegate(method).to(delegate).with_a_block  }
end
