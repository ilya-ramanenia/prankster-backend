get "/device_info/all" do
  success_response(200, response: DeviceInfo.all.as_json)
end

get "/child/all" do
  success_response(200, response: Child.all.as_json)
end

get "/parent/all" do
  success_response(200, response: Parent.all.as_json)
end


post "/reset_database" do
  exec 'pg:reset --confirm prankster-app'
  exec 'run rake db:migrate'

  success_response(200, response: "Reseted")
end