# RSpec matcher to spec delegations.
# Based on https://gist.github.com/awinograd/6158961
#
# Usage:
#
# describe Post do
#   it { should delegate(:name).to(:author) }                         # name         => author.name
#   it { should delegate(:name).to(:author).as(:name) }               # name         => author.name
#
#   it { should delegate(:name).to(:@author) }                        # name         => @author.name
#   it { should delegate(:name).to(:@author).as(:name) }              # name         => @author.name
#
#   it { should delegate(:name).to(author) }                          # name         => author.name
#   it { should delegate(:name).to(author).as(:name) }                # name         => author.name
#
#   it { should delegate(:name).to(:author).with_prefix }             # author_name  => author.name
#   it { should delegate(:name).to(:author).with_prefix(:writer) }    # writer_name  => author.name
#   it { should delegate(:writer).to(:author).as(:name) }             # writer       => author.name
#
#   it { should delegate(:name).with('Ms.')to(:author) }              # name('Ms.')  => author.name('Ms.')
#   it { should delegate(:name).with('Ms.')to(:author).with('Miss') } # name('Ms.')  => author.name('Miss')
#
#   it { should delegate(:name).to(:author).with_a_block }            # name(&block) => author.name(&block)
#   it { should delegate(:name).to(:author).without_a_block }         # name(&block) => author.name
#
#   it { should delegate(:name).to(:author).allow_nil }               # name         => author && author.name
#   it { should delegate(:name).to(:author).allow_nil(true) }         # name         => author && author.name
#   it { should delegate(:name).to(:author).allow_nil(false) }        # name         => author.name
# end

RSpec::Matchers.define(:delegate) do |method|
  match do |delegator|
    fail 'need to provide a "to"' unless delegate

    @method    = method
    @delegator = delegator

    allow_nil_ok? && delegate? && arguments_ok? && block_ok?
  end

  description do
    "delegate #{delegator_description} to #{delegate_description}#{nil_description}#{block_description}"
  end

  def failure_message
    message = failure_message_details(false)
    message.empty? ? super : message
  end

  def failure_message_when_negated
    message = failure_message_details(true)
    message.empty? ? super : message
  end

  chain(:to)              { |delegate|         @delegate         = delegate }
  chain(:as)              { |delegate_method|  @delegate_method  = delegate_method }
  chain(:allow_nil)       { |allow_nil = true| @nil_allowed      = allow_nil }
  chain(:with_prefix)     { |prefix = nil|     @prefix           = prefix || delegate.to_s.sub(/@/, '') }
  chain(:with)            { |*args|            @expected_args    = args; @args ||= args }
  chain(:with_a_block)    {                    @expected_block   = true  }
  chain(:without_a_block) {                    @expected_block   = false }

  alias_method :with_block,    :with_a_block
  alias_method :without_block, :without_a_block

  private

  attr_reader :method, :delegator, :delegate, :prefix, :expected_args, :args
  attr_reader

  def delegate?(test_delegate = delegate_double)
    case
    when delegate_is_an_attribute?
      delegate_to_attribute?(test_delegate)
    when delegate_is_a_method?
      delegate_to_method?(test_delegate)
    else
      delegate_to_object?
    end
  end

  def delegate_is_an_attribute?
    delegate.to_s[0] == '@'
  end

  def delegate_is_a_method?
    delegate.is_a?(String) || delegate.is_a?(Symbol)
  end

  def delegate_to_attribute?(test_delegate)
    actual_delegate = delegator.instance_variable_get(delegate)
    delegator.instance_variable_set(delegate, test_delegate)
    delegate_called?
  ensure
    delegator.instance_variable_set(delegate, actual_delegate)
  end

  def delegate_to_method?(test_delegate)
    enure_delegate_method_is_valid

    allow(delegator).to receive(delegate) { test_delegate }

    delegate_called?
  end

  def enure_delegate_method_is_valid
    fail "#{delegator} does not respond to #{delegate}"          unless delegator.respond_to?(delegate, true)
    fail "#{delegator}'s' #{delegate} method expects parameters" unless [0, -1].include?(delegator.method(delegate).arity)
  end

  def delegate_to_object?
    fail 'cannot verify "allow_nil" expectations when delegating to an object' unless @nil_allowed.nil?
    stub_delegation(delegate)
    delegate_called?
  end

  def delegator_method
    @delegator_method || (prefix ? :"#{prefix}_#{method}" : method)
  end

  def delegate_method
    @delegate_method || method
  end

  def delegate_called?
    @return_value = delegator.send(delegator_method, *args, &block)
    @return_value == self
  end

  def block
    @block ||= proc {}
  end

  def delegate_double
    double('delegate').tap { |delegate| stub_delegation(delegate) }
  end

  def stub_delegation(delegate)
    @delegated = false
    allow(delegate).to(receive(delegate_method)) do |*args, &block|
      @actual_args = args
      @actual_block = block
      @delegated = true
      self
    end
  end

  def allow_nil_ok?
    return true if @nil_allowed.nil?
    return true unless delegate.is_a?(String) || delegate.is_a?(Symbol)

    begin
      @allowed_nil = true
      delegate?(nil)
      @return_value_when_delegate_nil = @return_value
    rescue NoMethodError
      @allowed_nil = false
    end

    @nil_allowed == @allowed_nil && @return_value_when_delegate_nil.nil?
  end

  def arguments_ok?
    expected_args.nil? || @actual_args.eql?(expected_args)
  end

  def block_ok?
    case
    when @expected_block.nil?
      true
    when @expected_block
      @actual_block == @block
    else
      @actual_block.nil?
    end
  end

  def delegator_description
    "#{delegator_method}#{argument_description(args)}"
  end

  def delegate_description
    case
    when !args.eql?(expected_args)
      "#{delegate}.#{delegate_method}#{argument_description(expected_args)}"
    when delegate_method.eql?(delegator_method)
      "#{delegate}"
    else
      "#{delegate}.#{delegate_method}"
    end
  end

  def argument_description(args)
    args ? "(#{args.map { |a| format('%p', a) }.join(', ')})" : ''
  end

  def nil_description
    case
    when @nil_allowed.nil?
      ''
    when @nil_allowed
      ' with nil allowed'
    else
      ' with nil not allowed'
    end
  end

  def block_description
    case
    when @expected_block.nil?
      ''
    when @expected_block
      ' with a block'
    else
      ' without a block'
    end
  end

  def failure_message_details(negated)
    [
      return_value_failure_message(negated),
      argument_failure_message(negated),
      block_failure_message(negated),
      allow_nil_failure_message(negated)
    ].reject(&:empty?).join(' and ')
  end

  def return_value_failure_message(negated)
    case
    when !@delegated || @return_value == self
      ''
    else
      format('a return value of %p was returned instead of the delegate return value', @return_value)
    end
  end

  def argument_failure_message(negated)
    case
    when negated
      arguments_ok? && expected_args ? "was called with #{argument_description(@actual_args)}" : ''
    when arguments_ok?
      ''
    else
      "was called with #{argument_description(@actual_args)}"
    end
  end

  def block_failure_message(negated)
    case
    when @expected_block.nil? || (negated ^ block_ok?)
      ''
    when negated
      "a block was #{@expected_block ? '' : 'not '}passed"
    when @expected_block
      @actual_block.nil? ? 'a block was not passed' : "a different block #{@actual_block} was passed"
    else
      'a block was passed'
    end
  end

  def allow_nil_failure_message(negated)
    case
    when @nil_allowed.nil? || (negated ^ allow_nil_ok?)
      ''
    when !@return_value_when_delegate_nil.nil?
      'did not return nil'
    when negated
      "#{delegate} was #{@nil_allowed ? '' : 'not '}allowed to be nil"
    else
      "#{delegate} was #{@nil_allowed ? 'not ' : ''}allowed to be nil"
    end
  end
end
