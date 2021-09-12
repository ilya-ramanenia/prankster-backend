require 'sinatra/activerecord'
require 'array_enum'

## https://www.rubydoc.info/gems/activemodel/ActiveModel/Serializers/JSON

# class User < ActiveRecord::Base
#   has_many :books, :foreign_key => 'author_id'
# end

# class Book < ActiveRecord::Base
#   belongs_to :author, :class_name => 'User', :foreign_key => 'author_id', :validate => true
# ## or
#   belongs_to :author, :class_name => 'User', :inverse_of => 'author_id', :validate => true
# end

class BaseModel < ActiveRecord::Base
  @abstract_class = true

  # TODO: Move super(except: [:id, :device_id, :created_at] into parent
end

class Parent < BaseModel
  has_one     :device_info

  has_many    :child
  has_many    :created_region, :class_name => "Region"

  def self.build(name:)
    model = Parent.new

    model.name = name
    model.auth_token = SecureRandom.uuid
    model.child_id = []
    model.created_region_id = []

    return model
  end

  def as_json(*)
    super(
      include: :child,
      include: :created_region_id)
  end
end

class Child < BaseModel
  has_one     :device_info

  has_many  :parent
  has_many  :assigned_to_region, :class_name => "Region"

  has_many  :region_status

  def as_json(*)
    super(
      except: [
        :region_id, 
        :region_status_id])
  end

  def self.build(name:)
    model = Child.new

    model.name = name
    model.auth_token = SecureRandom.uuid
    model.connect_key = SecureRandom.uuid
    model.parent_id = []
    model.assigned_to_region_id = []
    model.region_status_id = []

    return model
  end

      # TODO: 
  # def as_json(*)
  #   super(
  #     except: []
  #     include: {    parent: {
  #                       only: [:name] } })
  #     include: :assigned_to_region)
  # end
  #
  # def assigned_to_region
  #   super || {}
  # end
end

class Region  < BaseModel
  belongs_to  :parent_created, :class_name => "Parent", :inverse_of => "created_region"
  belongs_to  :child_assigned, :class_name => "Child", :inverse_of => "assigned_to_region"

  has_many    :region_status, dependent: :destroy
  has_one     :last_status, :class_name => "RegionStatus", :inverse_of => "region"

  def as_json(*)
    super(
      only: [
        :name, 
        :lat, 
        :long],
      include: {   parent_created: {
                      only: [:name] } },
      include: {   child_assigned: {
                      only: [:name] } },
      include: :last_status)
  end
end

class RegionStatus  < BaseModel
  belongs_to :region
  belongs_to :child

  extend ArrayEnum
  array_enum events: {"enter" => 1, "exit" => 2}

  def as_json(*)
    super(
      only: [
        :event, 
        :created_at])
  end
end

class DeviceInfo < BaseModel
  enum platform: [ :ios, :android ]

  belongs_to  :child
  belongs_to  :parent

  def as_json(*)
    super(
      include: :child,
      include: :parent)
  end
end