
## Create Child (Entry point for child user)

post "/child/create" do
  name = params[:name].to_s

  child = Child.build(name: name)
  child.save

  success_response(201, response: child.json_auth)
end


## Get Child info (as Child)

get "/child" do
  auth_token = params[:auth_token].to_s
  name = params[:name].to_s

  child = Child.find_by(auth_token: auth_token)

  if child == nil
      return error_response(401, error: "unauthorised")
  end

  success_response(200, response: child.json_full)
end


## Update Child info (as Child)

post "/child" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s
  name = params[:name].to_s

  child = Child.find_by(auth_token: auth_token)

  if child == nil
      return error_response(401, error: "unauthorised")
  end

  child.name = name
  child.save

  success_response(202, response: child.json_full)
end