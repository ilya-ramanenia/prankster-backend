
post "/parent" do
  token = params[:token]
  name = params[:name]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  if device.account
    return error(403, "account already created")
  end

  parent = Parent.new_(device, name)
  parent.save
  
  success(201, parent.as_json)
end

get "/parent/:id" do
  parent_id = params[:id].to_i
  token = params[:token]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  parent=device.account&.parent
  if !parent
    return error(403, "device doesn't have account")
  end

  if parent.account.id != parent_id
    return error(403, "no access to this parent")
  end

  success(200, parent.as_json)
end

post "/parent/:id/assign_child" do
  parent_id = params[:id].to_i
  child_id = params[:child_id].to_i
  token = params[:token]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  parent=device.account&.parent
  if !parent
    return error(403, "device doesn't have account")
  end

  if parent.account.id != parent_id
    return error(403, "no access to this parent")
  end

  child = Account.find_by(id: child_id).child
  if !child
    return error(403, "no child found for this id")
  end

  if child.parent_id
    return error(403, "child already assigned")
  end

  child.parent_id = parent.id
  child.save
  parent.child_id = child.id
  parent.save

  success(200, parent.as_json)
end

get "/child/:id" do
  child_id = params[:id].to_i
  token = params[:token]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  child=device.account&.child
  if !child
    return error(403, "device doesn't have account")
  end

  if child.account.id != child_id
    return error(403, "no access to this child")
  end

  success(200, child.as_json)
end

get "/child" do
  child_id = params[:id].to_i
  token = params[:token]
  device = Device.find_by(token: token)
  if !device
    return error(401, "unauthorised")
  end

  child=device.account&.child
  if !child
    return error(403, "device doesn't have account")
  end

  if child.account.id != child_id
    return error(403, "no access to this child")
  end

  success(200, child.as_json)
end