require 'spec_helper'
require 'bebot/services/compare_branches'

describe Bebot::Services::CompareBranches do
  context 'when comparison is valid' do
    let(:perform) { described_class.new(repo:'org/rep', from:'foo', to:'bar').run }

    let(:mock_comparator) { double(
      repo:          'org/repo',
      from:          'foo',
      to:            'bar',
      staleness:     1234,
      commits:       1337,
      pull_requests: 123,
      contributors: [
        Bebot::Models::Contributor.new('login' => 'alice',   'gravatar_id' => '1234'),
        Bebot::Models::Contributor.new('login' => 'bob',     'gravatar_id' => '5678'),
        Bebot::Models::Contributor.new('login' => 'charlie', 'gravatar_id' => '90ab')
      ]
    )}

    let(:mock_dogapi) { double emit_point:nil }

    before do
      Bebot::Models::Comparator.stub new:mock_comparator
      Dogapi::Client.stub new:mock_dogapi
    end
  
    it "suceeds" do
      perform
    end

    it 'returns comparison data' do
      response = Hashie::Mash.new perform
      response.staleness.should == 1234
      response.contributors.length.should == 3
      response.contributors.last.login.should == 'charlie'
      response.contributors.last.gravatar_url.should =~ %r(gravatar.com.*90ab)
    end

    it "notifies Datadog" do
      mock_dogapi.should_receive(:emit_point).twice
      perform
    end

    xit "notifies Ducksboard" do
      DUCKSBOARD.should_receive 'something'
    end
  end
end
