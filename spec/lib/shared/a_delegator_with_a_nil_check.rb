shared_examples 'a delegator with a nil check' do
  it { should     delegate(method_name).to(receiver).allow_nil(true)  }
  it { should     delegate(method_name).to(receiver).allow_nil  }
  it { should_not delegate(method_name).to(receiver).allow_nil(false)  }
end
