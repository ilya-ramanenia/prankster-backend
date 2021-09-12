
## Create Child (Entry point for child user)

post "/child" do
  name = params[:name].to_s

  model = Child.build(name: name)
  model.save

  success_response(201, response: model.as_json)
end


## Connect Child to Parent

post "/parent/:id/connect_child" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s
  connect_key = params[:connect_key].to_s

  parent=Parent.find_by(id: id)
  if parent == nil
    return error_response(401, error: "unauthorised", debug: "parent id: #{id}")
  end

  if parent.auth_token != auth_token
    return error_response(401, error: "unauthorised")
  end

  child = Child.find_by(connect_key: connect_key)
  if child == nil
    return error_response(403, error: "forbidden", debug: "no child with connect key: #{connect_key}")
  end

  if child.parent_id.include?(parent.id)
    return error_response(403, error: "forbidden", debug: "already connected to child id: #{child.id}")
  end

  parent.child_id |= [child.id]
  parent.save

  child.parent_id |= [parent.id]
  child.save

  success_response(200, response: child.as_json)
end


## Update Child info (as Child)

post "/child/:id" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s
  name = params[:name].to_s

  child = Child.find_by(id: id)

  if child == nil
    return error_response(403, error: "not found")
  end

  if child.auth_token != auth_token
      return error_response(401, error: "unauthorised", debug: "unauthorised child id #{child.id}")
  end

  child.name = name
  child.save

  success_response(202, response: child.as_json)
end


## Get Child info (as Child)

get "/child/:id" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s
  name = params[:name].to_s

  child = Child.find_by(id: id)

  if child == nil
    return error_response(403, error: "not found")
  end

  if child.auth_token != auth_token
      return error_response(401, error: "unauthorised", debug: "unauthorised child id #{child.id}")
  end

  success_response(200, response: child.as_json)
end