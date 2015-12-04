shared_examples 'a simple delegator' do |method, delegate|
  it { should delegate(method).to(delegate)      }
  it { should delegate(method.to_s).to(delegate) }
  it { should delegate(method).to(delegate.to_s) }

  include_examples 'a delegator without a nil check', method, delegate
  include_examples 'a delegator without a block',     method, delegate
end
