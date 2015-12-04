shared_examples 'a delegator without a nil check' do |method, delegate|
  it { should     delegate(method).to(delegate).allow_nil(false)  }
  it { should_not delegate(method).to(delegate).allow_nil(true)  }
  it { should_not delegate(method).to(delegate).allow_nil  }
end
