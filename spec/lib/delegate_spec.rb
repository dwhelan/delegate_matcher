require 'spec_helper'

module RSpec
  module Matchers
    module DelegateMatcher

      describe 'errors' do
        it 'should require a "to"' do
          expect{ should delegate(:name) }.to raise_error do |error|
            expect(error.message).to match /need to provide a "to"/
          end
        end
      end
    end
  end
end
