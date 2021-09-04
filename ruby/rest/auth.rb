
post "/auth" do
  device_id = params[:device_id]

  if !device_id
    return error(500, "no device id")
  end
  
  device = Device.find_by(device_id: device_id)
  if !device
    device = Device.new_token(device_id)
    device.save
  end

  success(200, device.as_json)
end