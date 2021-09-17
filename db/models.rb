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

    return model
  end

  def as_json(*)
    super(
      include: [
        {
          child: {
            only: [
              :id,
              :name
            ] 
          }
        }
      ])
  end
end

class Child < BaseModel

  has_one     :device_info

  belongs_to  :parent
  has_many  :region, :inverse_of => "child_assigned"
  has_many  :region_status

  def self.build(name:)
    model = Child.new

    model.name = name
    model.auth_token = SecureRandom.uuid
    model.connect_key = SecureRandom.uuid

    return model
  end

  def as_json(*)
    super(
      include: [
        {
          parent: {
            only: [
              :id,
              :name
            ] 
          }
        },
        :region,
        :region_status
      ],
      except: [
        :parent_id,
      ])
  end
end

class Region  < BaseModel

  belongs_to  :parent_created, :class_name => "Parent", :inverse_of => "created_region"
  has_one  :child_assigned, :class_name => "Child", :inverse_of => "region"

  has_many    :region_status, dependent: :destroy
  has_one     :last_status, :class_name => "RegionStatus", :inverse_of => "region"

  def as_json(*)
    super(
      only: [
        :name, 
        :lat, 
        :long],
      include: [
        :parent_created,
        :child_assigned
      ])
  end
end

class RegionStatus  < BaseModel
  has_one :region
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
      include: [
        :child,
        :parent
      ])
  end
end