shared_examples 'a simple delegator' do |method_name, receiver|
  it { should delegate(method_name).to(receiver)      }
  it { should delegate(method_name.to_s).to(receiver) }
  it { should delegate(method_name).to(receiver.to_s) }

  include_examples 'a delegator without a nil check', method_name, receiver
  include_examples 'a delegator without a block',     method_name, receiver
end
