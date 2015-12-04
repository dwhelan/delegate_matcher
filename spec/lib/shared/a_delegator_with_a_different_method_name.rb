shared_examples 'a delegator with a different method name' do |other_name|
  it { should     delegate(method_name).to(receiver).as(other_name)  }
end
