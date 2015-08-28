require 'spec_helper'

describe 'Version' do

  before { load './lib/delegate_matcher/version.rb' }

  it('should be present') { expect(DelegateMatcher::VERSION).to_not be_empty }
end
