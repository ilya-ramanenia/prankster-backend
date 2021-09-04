get "/child_request/all" do
  success(200, ChildRequest.all.as_json)
end

get "/child/all" do
  success(200, Child.all.as_json)
end

get "/parent/all" do
  success(200, Parent.all.as_json)
end
