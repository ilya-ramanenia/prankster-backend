
## Get child info

get "/child/:id" do
  id = params[:id].to_i
  auth_token = params[:auth_token].to_s

  parent=Parent.find_by(auth_token: auth_token)
  if parent == nil
    return errorResponse(401, error: "unauthorised")
  end

  model=Child.find_by(id: id)

  if model == nil
    return errorResponse(403, error: "not found")
  end

  if model.parent_id.include? parent.id == false
    return errorResponse(401, error: "unauthorised", debug: "no access to child id: #{id}")
  end

  successResponse(200, response: model.as_json)
end