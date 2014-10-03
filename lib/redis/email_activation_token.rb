require 'redis'

dir = File.expand_path("email_activation_token", File.dirname(__FILE__))
require dir + "/version"
require dir + "/redis_ext"
