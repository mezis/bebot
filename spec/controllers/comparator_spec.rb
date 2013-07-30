require 'spec_helper'
require 'bebot/controllers/comparator'
require 'rack/test'

describe Bebot::Controllers::Comparator do
  include Rack::Test::Methods

  let(:app) { described_class }

  context 'when comparison is valid' do
    let(:perform) { get '/compare/org/repo/master...production' }
    let(:mock_comparator) { double(
      staleness: 1234,
      contributors: [
        Bebot::Models::Contributor.new('login' => 'alice',   'gravatar_id' => '1234'),
        Bebot::Models::Contributor.new('login' => 'bob',     'gravatar_id' => '5678'),
        Bebot::Models::Contributor.new('login' => 'charlie', 'gravatar_id' => '90ab')
      ]
    )}

    before do
      Bebot::Services::Comparator.stub new:mock_comparator
    end
  
    it "suceeds" do
      perform
      last_response.should be_ok
    end

    it 'returns comparison data' do
      perform
      response = Hashie::Mash.new JSON.parse(last_response.body)
      response.staleness.should == 1234
      response.contributors.length.should == 3
      response.contributors.last.login.should == 'charlie'
      response.contributors.last.gravatar_url.should =~ %r(gravatar.com.*90ab)
    end

    xit "notifies Datadog" do
      DATADOG.should_receive 'something'
    end

    xit "notifies Ducksboard" do
      DUCKSBOARD.should_receive 'something'
    end
  end
end