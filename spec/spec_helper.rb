require 'bundler/setup'
require 'coveralls'
Coveralls.wear!
Bundler.setup

require 'redis/email_activation_token'
require 'ffaker'
require 'ap'
