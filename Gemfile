source ENV.fetch('GEM_SOURCE', 'https://rubygems.org')

ruby '2.1.1'

gem 'octokit'         # githup API client
gem 'dogapi'          # DataDog client
gem 'rufus-scheduler' # task scheduler
gem 'httparty'        # simple HTTP abstraction

group :development do
  gem 'foreman'   # start processes, manage environement

  gem 'rake'      # like make, but Ruby
  gem 'pry'       # a better CLI
  gem 'pry-nav'
  gem 'timecop'   # manipulates the current time in tests
  gem 'rspec'     # test suite
  gem 'guard'     # autorun test suite
  gem 'guard-rspec'
  gem 'guard-bundler'
end

