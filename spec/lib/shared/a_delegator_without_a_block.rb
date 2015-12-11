shared_examples 'a delegator without a block' do
  it { should delegate(:name).to(receiver).without_block  }
  it { should delegate(:name).to(receiver).without_a_block  }

  it { should_not delegate(:name).to(receiver).with_block  }
  it { should_not delegate(:name).to(receiver).with_a_block  }
end
