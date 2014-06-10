require 'dotenv'

env = ENV.fetch('RACK_ENV', 'development')
Dotenv.load(".env.#{env}", '.env') 
