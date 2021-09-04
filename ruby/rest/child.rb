
post "/child" do
  token = params[:token]
  name = params[:name]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  if device.account
    return error(403, "account already created")
  end

  child = Child.new_(device, name)
  child.save
  
  success(201, child.as_json)



  
end