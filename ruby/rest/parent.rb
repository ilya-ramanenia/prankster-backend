require 'sinatra/activerecord'


## Create Parent (Entry point for parent user)

post "/parent/create" do
  name = params[:name].to_s

  parent = Parent.build(name: name)
  parent.save

  success_response(201, response: parent.json_auth)
end


## Update Parent info

post "/parent" do
  auth_token = params[:auth_token].to_s

  parent = Parent.find_by(auth_token: auth_token)
  if parent == nil
    return error_response(401, error: "unauthorised")
  end

  parent.name = params[:name].to_s
  parent.save
  
  success_response(202, response: parent.json_full)
end


## Get Parent info

get "/parent" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s

  parent = Parent.find_by(auth_token: auth_token)
  if parent == nil
    return error_response(401, error: "unauthorised")
  end

  success_response(200, response: parent.json_full)
end


## Connect Child to Parent

post "/parent/connect_child" do
  auth_token = params[:auth_token].to_s
  connect_key = params[:connect_key].to_s

  parent = Parent.find_by(auth_token: auth_token)
  if parent == nil
    return error_response(401, error: "unauthorised")
  end

  child = Child.find_by(connect_key: connect_key)
  if child == nil
    return error_response(403, error: "forbidden", debug: "no child with connect key: #{connect_key}")
  end

  if child.parent == parent
    return error_response(403, error: "forbidden", debug: "already connected to child id: #{child.id}")
  end

  parent.child << child
  child.save

  success_response(200, response: child.json_full)
end


## Get all Children (of Parent)

get "/parent/child" do
  auth_token = params[:auth_token].to_s
  name = params[:name].to_s

  parent = Parent.find_by(auth_token: auth_token)
  if parent == nil
    return error_response(401, error: "unauthorised")
  end

  success_response(200, response: parent.child.map { |c| c.json_short })
end


## Get Child info (as Parent)

get "/parent/child/:child_id" do
  child_id = params[:child_id].to_i
  auth_token = params[:auth_token].to_s
  name = params[:name].to_s

  parent = Parent.find_by(auth_token: auth_token)
  if parent == nil
    return error_response(401, error: "unauthorised")
  end

  child = Child.find_by(id: child_id)

  if child == nil
    return error_response(403, error: "not found", debug: "no child found with id: #{child_id}")
  end

  if !parent.child.exists?(child.id)
      return error_response(401, error: "unauthorised", debug: "parent not authorised to change child id #{child.id}")
  end

  success_response(200, response: child.json_full)
end


## Update Child info (as Parent)

post "/parent/child/:child_id" do
  child_id = params[:child_id].to_i
  auth_token = params[:auth_token].to_s
  name = params[:name].to_s

  parent = Parent.find_by(auth_token: auth_token)
  if parent == nil
    return error_response(401, error: "unauthorised")
  end

  child = Child.find_by(id: child_id)

  if child == nil
    return error_response(403, error: "not found", debug: "no child found with id: #{child_id}")
  end

  if !parent.child.exists?(child.id)
      return error_response(401, error: "unauthorised", debug: "parent not authorised to change child id #{child.id}")
  end

  child.name = name
  child.save

  success_response(202, response: child.json_full)
end