require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      describe 'as matching' do
        include_context 'Post delegation'

        context <<-END.gsub /^\s{6}/, '' do
          # With a block
          def name
            @author.other_name
          end
          END

          let(:matcher) { delegate(:name).to(:@author).as(:other_name) }

          it { expect(matcher.description).to match /to "@author".other_name/ }
          it { expect(matcher.failure_message_when_negated).to match(/to "@author".other_name/) }
          it { expect(matcher.as('bad_name').failure_message).to match(/to "@author".bad_name/) }
        end
      end
    end
  end
end
