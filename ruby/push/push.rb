require 'rpush'
require './config/rpush.rb'

require_relative './push_ios.rb'
require_relative './push_android.rb'

def send_silent_push(device, data:)
	if device.platform == "ios"
		send_silent_push_iOS(device.push_id, data: data)
	elsif device.platform == "android"
		send_silent_push_android(device.push_id, data: data)
	end
end

def send_message_push(device, title:, body:)
	if device.platform == "ios"
		send_message_push_iOS(device.push_id, title: title, body: body)
	elsif device.platform == "android"
		send_message_push_android(device.push_id, title: title, body: body)
	end
end