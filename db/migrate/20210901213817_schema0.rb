# t.references :x is just shorthand for t.column :x_id, :integer or t.integer :x_id

# belongs_to is an alias of reference

class Schema0 < ActiveRecord::Migration[6.0]

  def change
    create_table :parent do |t|
      t.string :name
      t.string :auth_token
      t.string :avatar_url

      t.timestamps
    end

    create_table :child do |t|
      t.references :parent

      t.string :name
      t.string :auth_token
      t.string :avatar_url
      t.string :connect_key

      t.timestamps
    end

    create_table :region_status do |t|
      t.references :child, null: false
      t.references :region, null: false

      t.string :events, array: true, null: false, default: []

      t.float :lat
      t.float :long

      t.timestamps
    end

    create_table :region do |t|
      t.references :parent_created, null: false, foreign_key: { to_table: 'parent' }
      t.references :child

      t.references :region_status
      t.references :last_status, foreign_key: { to_table: 'region_status' }

      t.string :name
      t.float :lat
      t.float :long
      t.integer :radius

      t.timestamps
    end

    create_table :device_info do |t|
      t.references :parent
      t.references :child

      t.string :push_id
      t.column :client, :string, null: false

      t.timestamps
    end
  end
end
