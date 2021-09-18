require 'memoist'

## Init app
extend Memoist
def init_android_app
	app = Rpush::Gcm::App.new
	app.name = "android_app"
	app.auth_key = "AAAAJNrbo5c:APA91bE-M2NGZTsnP44iPsX2NRhOpd59T-399adLmJT3UY3Tu2HTXFPHChVLLXAiW0jr42il07s3mrGjy3SHjeBqHn7J5r7SUiPlwJrqkTRe088808okxHSFy8t5p31Cn_WXFPNnn1FI"
	app.connections = 1
	app.save!
end
memoize :init_android_app

def send_silent_push_android(id, data:)
	n = Rpush::Gcm::Notification.new
	n.app = Rpush::Gcm::App.find_by_name("android_app")
	n.registration_ids = [id]
	n.priority = 'high'
	n.data = { message: "Maks soset salo" }
	n.priority = 'high'
	n.content_available = true
	n.save!
end


def send_message_push_android(id, title:, body:)
	n = Rpush::Gcm::Notification.new
	n.app = Rpush::Gcm::App.find_by_name("android_app")
	n.registration_ids = [id]
	n.priority = 'normal'

	n.notification = { 
		body: body,
		title: title,
		icon: 'myicon'
	}
	n.save!
end