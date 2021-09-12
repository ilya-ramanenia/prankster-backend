ENV['RACK_ENV'] = ENV['RACK_ENV'] || 'development'

require 'sinatra/activerecord/rake'

namespace :db do
  task :load_config do
    require './ruby/app.rb'
  end
end