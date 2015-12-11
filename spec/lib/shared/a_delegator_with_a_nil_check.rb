shared_examples 'a delegator with a nil check' do
  # it { should     delegate(:name).to(receiver).allow_nil(true)  }
  # it { should     delegate(:name).to(receiver).allow_nil  }
  # it { should_not delegate(:name).to(receiver).allow_nil(false)  }
end
