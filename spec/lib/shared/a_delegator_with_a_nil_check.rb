shared_examples 'a delegator with a nil check' do |method, delegate|
  it { should     delegate(method).to(delegate).allow_nil(true)  }
  it { should     delegate(method).to(delegate).allow_nil  }
  it { should_not delegate(method).to(delegate).allow_nil(false)  }
end
