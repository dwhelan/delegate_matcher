shared_examples 'with a block' do |method, delegate|
  it { should     delegate(method).to(delegate).with_block  }
  it { should     delegate(method).to(delegate).with_block  }
end

shared_examples 'without a block' do |method, delegate|
  it { should     delegate(method).to(delegate).without_block  }
  it { should     delegate(method).to(delegate).without_a_block  }
end
