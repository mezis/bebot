require 'pathname'
require 'rufus-scheduler'
require 'json'
require 'hashie'

dir = Pathname(__FILE__).parent
$:.unshift(dir) unless $:.include?(dir)

require 'bebot/services/compare_branches'

scheduler = Rufus::Scheduler.new

COMPARISONS = JSON.parse(ENV['BEBOT_COMPARISONS'])

COMPARISONS.each do |payload|
  scheduler.every '5m', first_in:'1s' do |job|
    Bebot::Services::CompareBranches.new(
      repo: payload['repo'], from: payload['from'], to: payload['to'],
      notify: %w(datadog log)
    ).run
  end
  
  scheduler.every '1h', first_at: Rufus::Scheduler.parse('9:05am Europe/London') do |job|
    Bebot::Services::CompareBranches.new(
      repo: payload['repo'], from: payload['from'], to: payload['to'],
      notify: %w(log slack)
    ).run
  end
end

$stderr.puts "starting scheduler"
scheduler.join
