require 'sinatra'

require 'sinatra/activerecord'
set :database_file, "../config/database.yml"
ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.pluralize_table_names = false
require './db/models.rb'

require_relative './rest/_debug.rb'
require_relative './rest/child.rb'
require_relative './rest/child_request.rb'
require_relative './rest/parent.rb'

before do
  content_type :json
end

not_found do
  status 404

  content_type :html
  erb :not_found
end

def successResponse(code, response: {})
  @result = {"status" => "ok"}
  @result["response"] = response
  status code
  erb :json

  # content_type :html
  # erb :json_html
end

def errorResponse(code, error: "", debug: nil)
  @result = {"status" => "error"}
  @result["error"] = error
  if debug != nil
    @result["debug"] = debug
  end
  status code
  erb :json

  # content_type :html
  # erb :json_html
end
