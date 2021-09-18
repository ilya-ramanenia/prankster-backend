
## Create child Device info

post "/child/device_info" do
  auth_token = params[:auth_token].to_s
  client = params[:client].to_s
  push_id = params[:push_id].to_s

  child = Child.find_by(auth_token: auth_token)
  if child == nil
      return error_response(401, error: "unauthorised")
  end

  device_info = DeviceInfo.new
  device_info.client = client
  device_info.push_id = push_id
  device_info.child = child
  device_info.save

  send_message_push(device_info, title: "VERY SUCCESSS", body: "Successfully registered to push #{child.name}")
  
  success_response(201, response: device_info.json_full)
end


## Get child Device info

get "/child/device_info" do
  auth_token = params[:auth_token].to_s

  child = Child.find_by(auth_token: auth_token)
  if child == nil
      return error_response(401, error: "unauthorised")
  end

  success_response(201, response: child.device_info.json_full)
end


## Create parent Device info

post "/parent/device_info" do
  auth_token = params[:auth_token].to_s
  client = params[:client].to_s
  push_id = params[:push_id].to_s

  parent = Parent.find_by(auth_token: auth_token)
  if parent == nil
      return error_response(401, error: "unauthorised")
  end

  device_info = DeviceInfo.new
  device_info.client = client
  device_info.push_id = push_id
  device_info.parent = parent
  device_info.save
  
  send_message_push(device_info, title: "VERY SUCCESSS", body: "Successfully registered to push #{parent.name}")
  
  success_response(201, response: device_info.json_full)
end


## Get parent Device info

get "/parent/device_info" do
  auth_token = params[:auth_token].to_s

  parent = Parent.find_by(auth_token: auth_token)
  if parent == nil
      return error_response(401, error: "unauthorised")
  end
  
  success_response(201, response: parent.device_info.json_full)
end