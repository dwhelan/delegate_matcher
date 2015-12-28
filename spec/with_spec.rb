require 'spec_helper'
require 'active_support/core_ext/module'

module RSpec
  module Matchers
    module DelegateMatcher
      shared_examples 'a delegator with empty args' do
        let(:matcher) { delegate(:name).with.to(:@author) }

        it { should matcher }
        it { expect(matcher.description).to eq 'delegate name() to "@author"' }

        it { should matcher.with }
        it { expect(matcher.with.description).to eq 'delegate name() to "@author"' }

        it { should matcher.with(no_args) }
        it { expect(matcher.with(no_args).description).to eq 'delegate name() to "@author".name(no args)' }

        it { expect(matcher.failure_message_when_negated).to match(/was called with ()/) }
      end

      shared_examples 'a delegator with no_args' do
        let(:matcher) { delegate(:name).with(no_args).to(:@author) }

        it { should matcher }
        it { expect(matcher.description).to eq 'delegate name(no args) to "@author"' }

        it { should matcher.with }
        it { expect(matcher.with.description).to eq 'delegate name(no args) to "@author".name()' }

        it { should matcher.with(no_args) }
        it { expect(matcher.with(no_args).description).to eq 'delegate name(no args) to "@author"' }

        it { expect(matcher.failure_message_when_negated).to match(/was called with ()/) }
      end

      shared_examples 'a delegator with same args' do |*args|
        let(:args_description) { args.map{|a| a.inspect}.join(', ') }
        let(:matcher) { delegate(:name).with(*args).to(:@author) }

        it { should matcher }
        it { expect(matcher.description).to eq %(delegate name(#{args_description}) to "@author") }

        it { should matcher.with(*args) }
        it { expect(matcher.with(*args).description).to eq %(delegate name(#{args_description}) to "@author") }
      end

      shared_examples 'a delegator with any args' do |*args|
        let(:matcher) { delegate(:name).with(*args).to(:@author).with(any_args) }

        it { should matcher }
        it { expect(matcher.description).to eq %(delegate name(#{args.map{|a| a.inspect}.join(', ')}) to "@author".name(*(any args))) }
      end

      shared_examples 'a delegator with anything' do |*args|
        let(:matcher) { delegate(:name).with(*args).to(:@author).with(anything) }

        it { should matcher }
        it { expect(matcher.description).to eq %(delegate name(#{args.map{|a| a.inspect}.join(', ')}) to "@author".name(anything)) }
      end

      describe 'argument matching' do
        include_context 'Post delegation'

        context <<-END.gsub /^\s{6}/, '' do
          # With no parameters
          def name
            @author.name
          end
        END
          it_behaves_like 'a delegator with empty args'
          it_behaves_like 'a delegator with no_args'
          it_behaves_like 'a delegator with same args'
          it_behaves_like 'a delegator with any args'

          it { should_not delegate(:name).with().to(:@author).with(anything) }
        end

        context <<-END.gsub /^\s{6}/, '' do
          # With optional parameters
          def name(*args)
            @author.name(*args)
          end
        END

          it_behaves_like 'a delegator with empty args'
          it_behaves_like 'a delegator with no_args'
          it_behaves_like 'a delegator with same args', 'Ms.'
          it_behaves_like 'a delegator with anything',  'Ms.'
          it_behaves_like 'a delegator with any args'
          it_behaves_like 'a delegator with any args',  'Ms.'
          it_behaves_like 'a delegator with any args',  'Ms.', 'Mrs.'

          it { should_not delegate(:name).with('Ms.').to(:@author).with(no_args) }
        end

        context <<-END.gsub /^\s{6}/, '' do
          # With a required parameter
          def name(title)
            @author.name(title)
          end
        END

          it_behaves_like 'a delegator with same args', 'Ms.'
          it_behaves_like 'a delegator with any args',  'Ms.'
          it_behaves_like 'a delegator with anything',  'Ms.'

          let(:matcher) { delegate(:name).to(:@author).with('Ms.') }

          it { should matcher }
          it { expect(matcher.description).to eq 'delegate name("Ms.") to "@author"' }
          it { expect(matcher.failure_message_when_negated).to match(/was called with \("Ms."\)/) }
          it { should_not delegate(:name).with('Ms.').to(:@author).with(no_args) }
        end

        context <<-END.gsub /^\s{6}/, '' do
          # With an optional parameter
          def name(title = 'Ms.')
            @author.name(title)
          end
          END

          it_behaves_like 'a delegator with same args', 'Ms.'
          it_behaves_like 'a delegator with any args',  'Ms.'
          it_behaves_like 'a delegator with anything',  'Ms.'

          let(:matcher) { delegate(:name).to(:@author).with('Ms.') }

          it { should matcher }
          it { expect(matcher.description).to eq 'delegate name("Ms.") to "@author"' }
          it { expect(matcher.failure_message_when_negated).to match(/was called with \("Ms."\)/) }
        end

        context <<-END.gsub /^\s{6}/, '' do
          # With arguments changed
          def name(title)
            @author.name(title.downcase)
          end
          END

          let(:matcher) { delegate(:name).with('Ms.').to(:@author).with('ms.') }

          it { should matcher }
          it { expect(matcher.description).to eq 'delegate name("Ms.") to "@author".name("ms.")' }
          it { expect(matcher.failure_message_when_negated).to match(/was called with \("ms."\)/) }
        end
      end
    end
  end
end
