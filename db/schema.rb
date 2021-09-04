# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_01_213817) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "child", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "region_status_id"
    t.bigint "region_setting_id"
    t.float "last_location_lat"
    t.float "last_location_long"
    t.datetime "last_location_timestamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_id"], name: "index_child_on_parent_id"
    t.index ["region_setting_id"], name: "index_child_on_region_setting_id"
    t.index ["region_status_id"], name: "index_child_on_region_status_id"
  end

  create_table "child_request", force: :cascade do |t|
    t.string "name"
    t.string "device_id"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "parent", force: :cascade do |t|
    t.bigint "child_id"
    t.bigint "region_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_id"], name: "index_parent_on_child_id"
    t.index ["region_id"], name: "index_parent_on_region_id"
  end

  create_table "region", force: :cascade do |t|
    t.bigint "parent_id"
    t.string "name"
    t.float "lat"
    t.float "long"
    t.integer "radius"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_id"], name: "index_region_on_parent_id"
  end

  create_table "region_setting", force: :cascade do |t|
    t.bigint "child_id"
    t.bigint "region_id"
    t.boolean "notify_inside"
    t.boolean "notify_outside"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_id"], name: "index_region_setting_on_child_id"
    t.index ["region_id"], name: "index_region_setting_on_region_id"
  end

  create_table "region_status", force: :cascade do |t|
    t.bigint "child_id"
    t.bigint "region_id"
    t.boolean "inside"
    t.boolean "outside"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_id"], name: "index_region_status_on_child_id"
    t.index ["region_id"], name: "index_region_status_on_region_id"
  end

end
