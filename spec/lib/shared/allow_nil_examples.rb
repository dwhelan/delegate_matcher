shared_examples 'allow_nil' do |method, delegate|
  it { should     delegate(method).to(delegate).allow_nil(true)  }
  it { should     delegate(method).to(delegate).allow_nil  }
  it { should_not delegate(method).to(delegate).allow_nil(false)  }
end

shared_examples 'disallow_nil' do |method, delegate|
  it { should     delegate(method).to(delegate).allow_nil(false)  }
  it { should_not delegate(method).to(delegate).allow_nil(true)  }
  it { should_not delegate(method).to(delegate).allow_nil  }
end
