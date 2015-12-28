require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      describe 'prefix matching' do
        include_context 'Post delegation'

        context <<-END.gsub(/^\s{6}/, '') do
          # With a default prefix
          def author_name
            @author.name
          end
          END

          let(:matcher) { delegate(:name).to(:@author).with_prefix }

          it { expect(matcher.description).to match(/author_name to "@author".name/) }
          it { expect(matcher.failure_message_when_negated).to match(/author_name to "@author".name/) }
        end

        context <<-END.gsub(/^\s{6}/, '') do
          # With a default prefix
          def writer_name
            @author.name
          end
          END

          let(:matcher) { delegate(:name).to(:@author).with_prefix('writer') }

          it { expect(matcher.description).to match(/writer_name to "@author".name/) }
          it { expect(matcher.failure_message_when_negated).to match(/writer_name to "@author".name/) }
        end
      end
    end
  end
end
