require 'memoist'

## Init app
extend Memoist
def init_android
	androidPushApp = Rpush::Gcm::App.new
	androidPushApp.name = "android_app"
	androidPushApp.auth_key = "..."
	androidPushApp.connections = 1
	androidPushApp.save!
end
memoize :init_android

def send_silent_push_android(id, data:)
	n = Rpush::Gcm::Notification.new
	# n.app = Rpush::Gcm::App.find_by_name("android_app")
	n.app = androidPushApp
	n.registration_ids = [id]
	n.data = { message: "Maks soset salo" }
	n.priority = 'high'        # Optional, can be either 'normal' or 'high'
	n.content_available = true # Optional
	n.save!
end


def send_message_push_android(id, title:, body:)
	n = Rpush::Gcm::Notification.new
	n.app = androidPushApp
	n.registration_ids = [id]
	n.priority = 'high'        # Optional, can be either 'normal' or 'high'
	# Optional notification payload. See the reference below for more keys you can use!
	n.notification = { body: 'ЕЕЕЕ',
		title: 'РОКККККК',
		icon: 'myicon'
	}
	n.save!
end