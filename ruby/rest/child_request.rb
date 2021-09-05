
## Create child request (Entry point for child user)

post "/child_request" do
  name = params[:name].to_s
  device_id = params[:device_id].to_s

  model = nil
  if device_id != nil
    model = ChildRequest.find_by(device_id: device_id)
  end

  if model == nil
    model = ChildRequest.new
    logger.debug("created ChildRequest")
  else
    logger.debug("found existing ChildRequest")
  end

  model.name = name
  model.connect_key = SecureRandom.uuid
  model.save

  successResponse(201, response: model.as_json)
end


## Create child and connect to parent

post "/parent/:id/connect_child" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s
  connect_key = params[:connect_key].to_s

  parent=Parent.find_by(id: id)
  if parent == nil
    return errorResponse(401, error: "unauthorised", debug: "parent id: #{id}")
  end

  if parent.auth_token != auth_token
    return errorResponse(401, error: "unauthorised")
  end

  child_request = ChildRequest.find_by(connect_key: connect_key)
  if child_request == nil
    return errorResponse(403, error: "not found", debug: "no child request with key: #{connect_key}")
  end

  if child_request.created_child != nil
    return errorResponse(403, error: "not already connected", debug: "already conencted to child: #{child_request.child_id}")
  end

  # Creating new child, assigning child to parent
  child = Child.build(child_request: child_request, parent: parent)
  child.save

  parent.save
  child_request.save

  successResponse(200, response: child.as_json)
end