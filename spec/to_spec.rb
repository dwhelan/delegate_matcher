require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher
      describe 'to' do
        include_context 'Post delegation'

        it 'should require a "to"' do
          expect { should delegate(:name) }.to raise_error do |error|
            expect(error.message).to match(/need to provide a "to"/)
          end
        end

        it 'should raise if the "to" method is invalid' do
          expect { should delegate(:name).to(:does_not_exist) }.to raise_error do |error|
            expect(error.message).to match(/undefined local variable or method .*does_not_exist/)
          end
        end

        it 'should raise if "to" constant is invalid' do
          expect { should delegate(:name).to(:DOES_NOT_EXIST) }.to raise_error do |error|
            expect(error.message).to match(/uninitialized constant .*DOES_NOT_EXIST/)
          end
        end

        it 'should raise if "to" instance variable is nil' do
          expect { should delegate(:name).to(:@does_not_exist) }.to raise_error do |error|
            expect(error.message).to match(/undefined method `name' for nil:NilClass/)
          end
        end
      end
    end
  end
end
