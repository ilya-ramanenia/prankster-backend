require 'sinatra/activerecord'


## Create Parent (Entry point for parent user)

post "/parent" do
  name = params[:name].to_s

  model = Parent.build(name: name)
  model.save

  success_response(201, response: model.as_json)
end


## Update Parent

post "/parent/:id" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s

  parent = Parent.find_by(id: id)
  if parent == nil
    return error_response(401, error: "unauthorised", debug: "no parent id: #{id}")
  end

  if parent.auth_token != auth_token
    return error_response(401, error: "unauthorised", debug: "unauthorised")
  end

  parent.name = params[:name].to_s
  parent.save
  
  success_response(202, response: parent.as_json)
end


## Get Parent info

get "/parent/:id" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s

  parent = Parent.find_by(id: id)
  if parent == nil
    return error_response(401, error: "unauthorised", debug: "no parent id: #{id}")
  end

  if parent.auth_token != auth_token
    return error_response(401, error: "unauthorised", debug: "unauthorised")
  end

  success_response(200, response: parent.as_json)
end


## Connect Child to Parent

post "/parent/:id/connect_child" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s
  connect_key = params[:connect_key].to_s

  parent = Parent.find_by(id: id)
  if parent == nil
    return error_response(401, error: "unauthorised", debug: "no parent id: #{id}")
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


## Update Child info (as Parent)

post "/parent/:id/child/:child_id" do
  id = params[:id].to_i
  child_id = params[:child_id].to_i
  auth_token = params[:auth_token].to_s
  name = params[:name].to_s

  parent = Parent.find_by(id: id)
  if parent == nil
    return error_response(401, error: "unauthorised", debug: "no parent id: #{id}")
  end

  if parent.auth_token != auth_token
    return error_response(401, error: "unauthorised")
  end

  child = Child.find_by(id: child_id)

  if child == nil
    return error_response(403, error: "not found", debug: "no child found with id: #{child_id}")
  end

  if !parent.child_id.include?(child.id)
      return error_response(401, error: "unauthorised", debug: "parent not authorised to change child id #{child.id}")
  end

  child.name = name
  child.save

  success_response(202, response: child.as_json)
end


## Get Child info (as Parent)

get "/parent/:id/child/:child_id" do
  id = params[:id].to_i
  child_id = params[:child_id].to_i
  auth_token = params[:auth_token].to_s
  name = params[:name].to_s

  parent = Parent.find_by(id: id)
  if parent == nil
    return error_response(401, error: "unauthorised", debug: "no parent id: #{id}")
  end

  if parent.auth_token != auth_token
    return error_response(401, error: "unauthorised")
  end

  child = Child.find_by(id: child_id)

  if child == nil
    return error_response(403, error: "not found", debug: "no child found with id: #{child_id}")
  end

  if !parent.child_id.include?(child.id)
      return error_response(401, error: "unauthorised", debug: "parent not authorised to change child id #{child.id}")
  end

  success_response(200, response: child.as_json)
end


## Get all Children (of Parent)

get "/parent/:id/child" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s
  name = params[:name].to_s

  parent = Parent.find_by(id: id)
  if parent == nil
    return error_response(401, error: "unauthorised", debug: "no parent id: #{id}")
  end

  if parent.auth_token != auth_token
    return error_response(401, error: "unauthorised")
  end

  success_response(200, response: parent.child.map { |c| [c.id, c.name] })
end