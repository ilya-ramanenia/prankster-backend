require "sinatra/activerecord"

# class Device < ActiveRecord::Base
#   has_one :account

#   def self.new_token(device_id)
#     device = Device.new
#     device.device_id = device_id
#     device.token = SecureRandom.uuid
#     return device
#   end

#   def as_json(*)
#     result = super(except: [:account_id, :created_at, :id])
#     result[:account] = account ? account.as_json : nil
#     result
#   end
# end

# class Account < ActiveRecord::Base
#   has_one :device
#   has_one :parent
#   has_one :child

#   def type
#     if parent
#       return "parent"
#     elsif child
#       return "child"
#     else
#       return null
#     end
#   end

#   def as_json(*)
#     result = super(except: [:device_id, :created_at, :child_id, :parent_id], methods: :type)
#     result[:child] = child ? child.as_json : nil
#     result[:parent] = parent ? parent.as_json : nil
#     result
#   end
# end


class BaseModel < ActiveRecord::Base
  @abstract_class = true
end


class ChildRequest < BaseModel

  def as_json(*)
    super(except: [:id, :device_id])
  end
end

class Parent < BaseModel
  has_many :child
  has_many :region

  def self.new_(device, name)
    parent = Parent.new

    return parent
  end

  def as_json(*)
    result = super(except: [:id, :child_id, :created_at, :region_id], include: :child)
    result[:name] = account.name
    result
  end
end

class Child < BaseModel
  has_many :parent
  has_many :region
  has_many :region_status
  has_many :region_setting


  def self.new_(device, name)
    child = Child.new

    return child
  end

  def as_json(*)
    result = super(except: [:id, :parent_id, :created_at, :region_id, :region_status_id, :region_setting_id], include: :parent)
    result[:name] = account.name
    result
  end
end

class Region  < BaseModel
  belongs_to :parent
  has_many :child
end

class RegionStatus  < BaseModel
  belongs_to :child
  belongs_to :region
end

class RegionSetting  < BaseModel
  belongs_to :child
  belongs_to :region
end