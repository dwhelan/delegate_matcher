shared_examples 'a simple delegator' do
  it { should delegate(method_name).to(receiver)      }
  it { should delegate(method_name.to_s).to(receiver) }

  it { should_not delegate(:to_s).to(receiver) }

  include_examples 'a delegator without a block'
end
