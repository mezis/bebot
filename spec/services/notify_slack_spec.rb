require 'spec_helper'
require 'time'
require 'timecop'

module Bebot
  module Services
    describe NotifySlack do
      subject { described_class.new(mock_comparator) }
      let(:mock_comparator) { double(
        repo:          'org/repo',
        from:          'foo',
        to:            'bar',
        staleness:     staleness,
        commits:       1337,
        pull_requests: 123,
        contributors: [
          Bebot::Models::Contributor.new('login' => 'alice',   'gravatar_id' => '1234'),
          Bebot::Models::Contributor.new('login' => 'bob',     'gravatar_id' => '5678'),
          Bebot::Models::Contributor.new('login' => 'charlie', 'gravatar_id' => '90ab')
        ]
      )}
      let(:notifier) { double(ping: nil) }
      before do
        allow(Slack::Notifier).to receive(:new).and_return(notifier)
      end

      let(:team)           { ENV["SLACK_TEAM"] }
      let(:slack_token)    { ENV["SLACK_TOKEN"] }
      let(:channel)        { ENV["SLACK_CHANNEL"] }
      let(:slack_username) { ENV["SLACK_USERNAME"] }

      context 'when branch staleness is high enough' do
        let(:staleness) { 1234 }
        it 'notifies the slack channel' do
          expect(Slack::Notifier).to receive(:new)
            .with(team, slack_token, channel: channel, username: slack_username)

          Timecop.freeze(Time.parse("2014-03-05 13:00:00")) do
            subject.run
          end
        end

        context 'when outside of the deploy window' do
          context 'from Mon-Thu after 16:00' do
            it 'does not notify the slack channel' do
              expect(Slack::Notifier).to_not receive(:new)
                .with(team, slack_token, channel: channel, username: slack_username)

              Timecop.freeze(Time.parse("2014-03-02 18:00:00")) do
                subject.run
              end
            end
          end

          context 'on a Friday after 12:00' do
            it 'does not notify the slack channel' do
              expect(Slack::Notifier).to_not receive(:new)
                .with(team, slack_token, channel: channel, username: slack_username)

              Timecop.freeze(Time.parse("2014-03-07 13:00:00")) do
                subject.run
              end
            end
          end
        end
      end

      context 'when branch staleness is too low' do
        let(:staleness) { 0 }

        it 'does not notify the slack channel' do
          expect(Slack::Notifier).to_not receive(:new)
            .with(team, slack_token, channel: channel, username: slack_username)

          subject.run
        end
      end
    end
  end
end
