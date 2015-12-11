shared_examples 'a delegator without a nil check' do
  # it { should     delegate(:name).to(receiver).allow_nil(false)  }
  # it { should_not delegate(:name).to(receiver).allow_nil(true)  }
  # it { should_not delegate(:name).to(receiver).allow_nil  }
end
