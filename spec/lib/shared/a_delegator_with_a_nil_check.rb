shared_examples 'a delegator with a nil check' do
  xit { should     delegate(:name).to(receiver).allow_nil(true)  }
  xit { should     delegate(:name).to(receiver).allow_nil  }
  xit { should_not delegate(:name).to(receiver).allow_nil(false)  }
end
