post "/child_request" do
  name = params[:name]
  device_id = params[:device_id]

  model = nil
  if device_id != nil
    model = ChildRequest.find_by(device_id: device_id)
    logger.debug("Found existing ChildRequest")
  else
    model = ChildRequest.new
    logger.debug("Created ChildRequest")
  end

  model.name = name
  model.token = SecureRandom.uuid
  model.save

  success(201, model.as_json)
end