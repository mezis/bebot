source ENV.fetch('GEM_SOURCE', 'https://rubygems.org')

ruby '2.1.1'

# githup API client
gem 'octokit',         require: false

# DataDog client
gem 'dogapi',          require: false

# task scheduler
gem 'rufus-scheduler', require: false

# simple HTTP abstraction
gem 'httparty',        require: false 

# configuration through the environment
gem 'dotenv',          require: false

# syntax sugar - javascript-like hashes
gem 'hashie',          require: false

# push messages to Slack chatrooms
gem 'slack-notifier',  require: false

# compute business hours
gem 'business_time',   require: false


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

