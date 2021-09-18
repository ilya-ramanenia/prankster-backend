get "/device_info/all" do
  success_response(200, response: DeviceInfo.all.as_json)
end

get "/child/all" do
  success_response(200, response: Child.all.as_json)
end

get "/parent/all" do
  success_response(200, response: Parent.all.as_json)
end


require './ruby/push/push.rb'

post "/child/send_push" do
  auth_token = params[:auth_token].to_s
  title = params[:title].to_s
  body = params[:body].to_s

  child = Child.find_by(auth_token: auth_token)
  if child == nil
      return error_response(401, error: "unauthorised")
  end

  device_info = child.device_info
  if device_info == nil
      return error_response(403, error: "error", debug: "no device_info in child #{child.id}")
  end

  send_message_push(device_info, title: title, body: body)

  success_response(200, response: nil)
end

post "/parent/send_push" do
  auth_token = params[:auth_token].to_s
  title = params[:title].to_s
  body = params[:body].to_s

  parent = Parent.find_by(auth_token: auth_token)
  if parent == nil
      return error_response(401, error: "unauthorised")
  end

  device_info = parent.device_info
  if device_info == nil
      return error_response(403, error: "error", debug: "no device_info in parent #{parent.id}")
  end

  send_message_push(device_info, title: title, body: body)

  success_response(200, response: nil)
end


post "/reset_database" do
  exec 'pg:reset --confirm prankster-app'
  exec 'run rake db:migrate'

  success_response(200, response: "Reseted")
end