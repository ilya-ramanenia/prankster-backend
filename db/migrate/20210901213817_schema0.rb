# t.references :x is just shorthand for t.column :x_id, :integer or t.integer :x_id

# belongs_to is an alias of reference


class Schema0 < ActiveRecord::Migration[6.0]

  def change
    create_table :child_request do |t|
      t.references :child

      t.string :name
      t.string :device_id
      t.string :connect_key

      t.timestamps
    end

    create_table :parent do |t|
      t.references :child, array: true
      t.references :created_region, array: true

      t.string :name
      t.string :last_device_id
      t.string :auth_token

      t.timestamps
    end

    create_table :child do |t|
      t.references :parent, array: true
      t.references :child_request

      t.references :region, array: true
      t.references :region_status, array: true
      
      t.string :name

      t.timestamps
    end

    create_table :region_status do |t|
      t.references :child
      t.references :region

      t.string :events, array: true, null: false, default: []

      t.float :lat
      t.float :long

      t.timestamps
    end

    create_table :region do |t|
      t.references :parent
      t.references :child, array: true

      t.references :region_status, array: true
      t.references :last_status, foreign_key: { to_table: 'region_status' }

      t.string :name
      t.float :lat
      t.float :long
      t.integer :radius

      t.timestamps
    end
  end
end
