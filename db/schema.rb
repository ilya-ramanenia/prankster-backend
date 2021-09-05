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
    t.bigint "parent_id", array: true
    t.bigint "child_request_id"
    t.bigint "region_id", array: true
    t.bigint "region_status_id", array: true
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_request_id"], name: "index_child_on_child_request_id"
    t.index ["parent_id"], name: "index_child_on_parent_id"
    t.index ["region_id"], name: "index_child_on_region_id"
    t.index ["region_status_id"], name: "index_child_on_region_status_id"
  end

  create_table "child_request", force: :cascade do |t|
    t.bigint "child_id"
    t.string "name"
    t.string "device_id"
    t.string "connect_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_id"], name: "index_child_request_on_child_id"
  end

  create_table "parent", force: :cascade do |t|
    t.bigint "child_id", array: true
    t.bigint "created_region_id", array: true
    t.string "name"
    t.string "last_device_id"
    t.string "auth_token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_id"], name: "index_parent_on_child_id"
    t.index ["created_region_id"], name: "index_parent_on_created_region_id"
  end

  create_table "region", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "child_id", array: true
    t.bigint "region_status_id", array: true
    t.bigint "last_status_id"
    t.string "name"
    t.float "lat"
    t.float "long"
    t.integer "radius"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_id"], name: "index_region_on_child_id"
    t.index ["last_status_id"], name: "index_region_on_last_status_id"
    t.index ["parent_id"], name: "index_region_on_parent_id"
    t.index ["region_status_id"], name: "index_region_on_region_status_id"
  end

  create_table "region_status", force: :cascade do |t|
    t.bigint "child_id"
    t.bigint "region_id"
    t.string "events", default: [], null: false, array: true
    t.float "lat"
    t.float "long"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_id"], name: "index_region_status_on_child_id"
    t.index ["region_id"], name: "index_region_status_on_region_id"
  end

  add_foreign_key "region", "region_status", column: "last_status_id"
end
