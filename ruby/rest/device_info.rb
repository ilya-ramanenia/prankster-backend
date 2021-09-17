
## Device info for Child

post "/child/:id/device_info" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s
  platform = params[:platform].to_s
  push_id = params[:push_id].to_s

  child = Child.find_by(id: id)
  if child == nil
    return error_response(403, error: "not found", debug: "no child found with id: #{id}")
  end

  if child.auth_token != auth_token
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

post "/parent/:id/device_info" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s
  platform = params[:platform].to_s
  push_id = params[:push_id].to_s

  parent=Parent.find_by(id: id)
  if parent == nil
    return error_response(403, error: "not found", debug: "no parent found with id: #{id}")
  end

  if parent.auth_token != auth_token
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