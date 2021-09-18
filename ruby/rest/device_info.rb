
## Device info for Child

post "/child/device_info" do
  auth_token = params[:auth_token].to_s
  platform = params[:platform].to_s
  push_id = params[:push_id].to_s

  child = Child.find_by(auth_token: auth_token)
  if child == nil
      return error_response(401, error: "unauthorised")
  end

  model = DeviceInfo.new
  model.platform = platform
  model.push_id = push_id
  model.child << child
  model.save

  send_message_push(model, title: "WOW", body: "Successfully registered to push #{child.name}")
  
  success_response(201, response: model.as_json)
end


## Device info for Parent

post "/parent/device_info" do
  auth_token = params[:auth_token].to_s
  platform = params[:platform].to_s
  push_id = params[:push_id].to_s

  parent = Parent.find_by(auth_token: auth_token)
  if parent == nil
      return error_response(401, error: "unauthorised")
  end

  model = DeviceInfo.new
  model.platform = platform
  model.push_id = push_id
  model.parent_id = parent.id
  model.save
  
  send_message_push(model, title: "WOW", body: "Successfully registered to push #{child.name}")
  
  success_response(201, response: model.as_json)
end