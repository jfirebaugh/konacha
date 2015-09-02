require 'spec_helper'

describe Konacha, type: :feature do
  before { Konacha.mode = :server }

  describe 'suite/test links' do
    let(:spec_file)  { 'empty_suite_and_test_spec' }
    let(:suite_name) { 'A test suite' }
    let(:test_name)  { 'A known test name' }

    before { visit '/' }

    describe 'suite link' do
      subject{ page.find_link('A test suite') }

      it 'should contain spec path and grep string' do
        subject['href'].should == "#{page.current_url}#{spec_file}/?grep=#{URI.encode(suite_name)}"
      end
    end

    describe 'replay link (arrow icon)' do
      subject{ page.find(%Q{a[href="#{page.current_url}#{spec_file}/?grep=#{URI.encode([suite_name, test_name].join(' '))}"]}) }

      it 'should contain spec path and grep string' do
        subject.should_not be_nil
      end
    end
  end
end
