require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      describe 'return value matching' do
        include_context 'Post delegation'

        context <<-END.gsub /^\s{6}/, '' do
          # With a different return value
          def name
            @author.name
            'Ann Rand'
          end
          END

          it { should_not matcher }
          it { expect(matcher.failure_message).to match(/a value of \"Ann Rand\" was returned instead of/) }

          describe 'without_return' do
            let(:matcher) { delegate(:name).to(:@author).without_return }

            it { should matcher }
            it { expect(matcher.description).to match(/ without using delegate return value/) }
            it { expect(matcher.failure_message_when_negated).to match(/ without using delegate return value/) }
          end

          describe 'and_return' do
            let(:matcher) { delegate(:name).to(:@author).and_return('Ann Rand') }

            it { should matcher }
            it { expect(matcher.description).to match(/ and return "Ann Rand"/) }
            it { expect(matcher.failure_message_when_negated).to match(/ and return "Ann Rand"/) }
          end

          describe 'and_return incorrect value' do
            let(:matcher) { delegate(:name).to(:@author).and_return('Isaac Asimov') }

            it { should_not matcher }
            it { expect(matcher.failure_message).to match(/a value of "Ann Rand" was returned instead of "Isaac Asimov"/) }
          end
        end
      end
    end
  end
end
