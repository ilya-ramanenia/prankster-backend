require "sinatra"

require "sinatra/activerecord"
set :database_file, "../config/database.yml"
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.pluralize_table_names = false
require "./db/models.rb"

configure :development do |c|
  require 'sinatra/reloader'
  c.also_reload "./ruby/rest/*.rb"
  c.also_reload "./db/**.rb"
  c.after_reload do
    puts 'reloaded'
  end
end

require_relative "./rest/_debug.rb"
require_relative "./rest/auth.rb"
require_relative "./rest/child.rb"
require_relative "./rest/child_request.rb"
require_relative "./rest/parent.rb"

before do
  content_type :json
end

not_found do
  status 404
  content_type :html
  erb :not_found
end

def success(statusCode, response = {})
  result = {"status" => "ok"}
  result["response"] = response
  status statusCode

  pretty_result = JSON.pretty_generate(result)
  puts pretty_result
  pretty_result
end

def error(statusCode, errorDescription = "")
  result = {"status" => "error"}
  result["error"] = errorDescription
  status statusCode

  pretty_result = JSON.pretty_generate(result)
  puts pretty_result
  pretty_result
end
