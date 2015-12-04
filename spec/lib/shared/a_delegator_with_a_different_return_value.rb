shared_examples 'a delegator with a different return value' do |expected_return_value|
  it { should     delegate(method_name).to(receiver).without_return  }
  it { should_not delegate(method_name).to(receiver)  }
end
