require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      describe 'block matching' do
        include_context 'Post delegation'

        context <<-END.gsub /^\s{6}/, '' do
          # With a block
          def name(&block)
            @author.name(&block)
          end
          END

          it { should matcher.with_block }
          it { should matcher.with_a_block }
          it { expect(matcher.with_block.description).to match /with a block/ }
          it { expect(matcher.with_block.failure_message_when_negated).to match(/a block was passed/) }

          it { should_not matcher.without_block }
          it { expect(matcher.without_block.failure_message).to match(/a block .* was passed/) }
        end

        context <<-END.gsub /^\s{6}/, '' do
          # Without a block
          def name(&block)
            @author.name
          end
          END

          it { should matcher.without_block }
          it { should matcher.without_a_block }
          it { expect(matcher.without_block.description).to match /without a block/ }
          it { expect(matcher.without_block.failure_message_when_negated).to match(/a block was not passed/) }

          it { should_not matcher.with_block }
          it { expect(matcher.with_block.failure_message).to match(/a block was not passed/) }
        end

        context <<-END.gsub /^\s{6}/, '' do
          # With a custom block
          def name(&block)
            @author.name { 'yo' }
          end
          END

          # To extract the proc source it must not eval'd so we redefine the method here
          before do
            klass.class_eval do
              def name(&block)
                @author.name { 'yo' }
              end
            end
          end

          # To extract the proc source it must be the only proc defined on the same line
          let(:prc) do
            proc { 'yo' }
          end

          let(:matcher) { delegate(:name).to(:@author).with_block(&prc) }

          it { should matcher }

          it { expect(matcher.description).to match(/with block "proc { "yo" }"/) }
          it { expect(matcher.failure_message_when_negated).to match(/with block "proc { "yo" }"/) }

          it { should_not matcher.without_block }
          it { expect(matcher.without_block.failure_message).to match(/a block .* was passed/) }
        end
      end
    end
  end
end
