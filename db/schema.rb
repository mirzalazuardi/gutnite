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

ActiveRecord::Schema[8.0].define(version: 2025_08_09_075643) do
  create_table "follows", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "followed_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_user_id"], name: "index_follows_on_followed_user_id"
    t.index ["follower_id", "followed_user_id"], name: "index_follows_on_follower_id_and_followed_user_id", unique: true
    t.index ["follower_id"], name: "index_follows_on_follower_id"
  end

  create_table "sleep_records", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "went_to_bed_at"
    t.datetime "woke_up_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "duration", precision: 5, scale: 2
    t.index ["duration"], name: "index_sleep_records_on_duration", order: :desc
    t.index ["user_id", "went_to_bed_at"], name: "index_sleep_records_on_user_id_and_went_to_bed_at"
    t.index ["user_id"], name: "index_sleep_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "follows", "users", column: "followed_user_id"
  add_foreign_key "follows", "users", column: "follower_id"
  add_foreign_key "sleep_records", "users"
end
