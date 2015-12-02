# noinspection RubyResolve

require 'spec_helper'

describe 'DelegateTo matcher' do
  # :nocov:
  let(:post) do
    Class.new do
      attr_accessor :authors, :any

      def any_alive?
        authors.any?(&:alive?)
      end

      def all_alive?
        authors.all?(&:alive?)
      end

      def inspect
        'post'
      end
    end.new
  end

  let(:authors) do
    klass = Class.new do
      attr_accessor :alive

      def name
        'Catherine Asaro'
      end

      def alive?
        alive
      end

      def inspect
        'author'
      end
    end
    [klass.new, klass.new]
  end
  # :nocov:

  subject { post }
  before  { post.authors = authors }

  # xdescribe 'to_any' do
  #   context('with no authors alive') {                                        its(:any_alive?) { should be false } }
  #   context('with one author alive') { before { authors.first.alive = true }; its(:any_alive?) { should be true } }
  #
  #   it { should delegate(:any_alive?).to_any(:authors) }
  # end
  #
  # xdescribe 'to_all' do
  #   context('with no authors alive')  {                                                 its(:all_alive?) { should be false } }
  #   context('with one author alive')  { before { authors.first.alive = true };          its(:all_alive?) { should be false } }
  #   context('with all authors alive') { before { authors.each { |a| a.alive = true } }; its(:all_alive?) { should be true } }
  #
  #   it { should delegate(:all_alive?).to_all(authors) }
  # end
end
