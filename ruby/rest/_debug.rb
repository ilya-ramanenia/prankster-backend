get "/child_request/all" do
  successResponse(200, response: ChildRequest.all.as_json)
end

get "/child/all" do
  successResponse(200, response: Child.all.as_json)
end

get "/parent/all" do
  successResponse(200, response: Parent.all.as_json)
end
