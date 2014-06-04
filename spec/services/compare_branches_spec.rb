require 'spec_helper'
require 'bebot/services/compare_branches'

describe Bebot::Services::CompareBranches do
  context 'when comparison is valid' do
    let(:args)    { { repo:'org/rep', from:'foo', to:'bar' } }
    let(:perform) { described_class.new(args).run }

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
      allow(Bebot::Models::Comparator).to receive(:new) { mock_comparator }
      allow(Dogapi::Client).to receive(:new) { mock_dogapi }
      allow_any_instance_of(Bebot::Services::NotifySlack).to receive(:run) { nil }
    end
  
    it "suceeds" do
      perform
    end

    it 'returns comparison data' do
      response = Hashie::Mash.new perform
      expect(response.staleness).to eq(1234)
      expect(response.contributors.length).to eq(3)
      expect(response.contributors.last.login).to eq('charlie')
      expect(response.contributors.last.gravatar_url).to match(%r(gravatar.com.*90ab))
    end

    context 'when passing Datadog in the notify list' do
      before do
        args.merge!({notify: %w{datadog}})
      end

      it "notifies Datadog" do
        expect(mock_dogapi).to receive(:emit_point).twice
        perform
      end
    end

    xit "notifies Ducksboard" do
      expect(DUCKSBOARD).to receive('something')
    end

    xit "Notifies Slack"
  end
end
