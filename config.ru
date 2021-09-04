# @environment = ENV['ENV'] || 'development'

require "./ruby/app.rb"
run Sinatra::Application
$stdout.sync = true