
## Create parent (Entry point for child user)

post "/parent" do
  name = params[:name].to_s
  device_id = params[:device_id].to_s

  model = Parent.new
  model.auth_token = SecureRandom.uuid
  model.last_device_id = device_id
  model.name = name

  model.save
  
  successResponse(201, response: model.as_json)
end


## Update parent

post "/parent/:id" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s

  parent=Parent.find_by(id: id)
  if parent == nil
    return errorResponse(401, error: "unauthorised", debug: "no parent id: #{id}")
  end

  if parent.auth_token != auth_token
    return errorResponse(401, error: "unauthorised", debug: "unauthorised")
  end

  parent.name = params[:name].to_s
  parent.save
  
  successResponse(200, response: parent.as_json)
end


## Get parent info

get "/parent/:id" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s

  parent=Parent.find_by(id: id)
  if parent == nil
    return errorResponse(401, error: "unauthorised", debug: "no parent id: #{id}")
  end

  if parent.auth_token != auth_token
    return errorResponse(401, error: "unauthorised", debug: "unauthorised")
  end

  successResponse(200, response: parent.as_json)
end