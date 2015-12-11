shared_examples 'a delegator with args and a block' do |*args|
  include_examples 'a delegator with args', *args
  include_examples 'a delegator with a block'

  it { should delegate(:name).to(receiver).with(*args).with_block  }
end
