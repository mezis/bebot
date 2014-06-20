unless %w(staging production).include?(ENV['RACK_ENV'])
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)
  task :default => :spec
end