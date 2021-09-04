class Schema0 < ActiveRecord::Migration[6.0]
  def change
    
    create_table :child_request do |t|
      t.references :child

      t.string :name
      t.string :device_id
      t.string :token

      t.timestamps
    end

    create_table :parent do |t|
      t.references :child
      t.references :region

      t.timestamps
    end

    create_table :child do |t|
      t.belongs_to :parent

      t.references :child_request

      t.references :region_status
      t.references :region_setting

      t.float :last_location_lat
      t.float :last_location_long
      t.datetime :last_location_timestamp

      t.timestamps
    end

    create_table :region do |t|
      t.references :parent

      t.string :name
      t.float :lat
      t.float :long
      t.integer :radius

      t.timestamps
    end

    create_table :region_status do |t|
      t.references :child
      t.references :region

      t.boolean :inside
      t.boolean :outside

      t.timestamps
    end

    create_table :region_setting do |t|
      t.references :child
      t.references :region

      t.boolean :notify_inside
      t.boolean :notify_outside

      t.timestamps
    end

  end
end
