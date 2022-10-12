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

ActiveRecord::Schema[7.0].define(version: 2022_06_28_090529) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.text "description"
    t.bigint "user_id", null: false
    t.bigint "skill_id", null: false
    t.string "activity_type"
    t.date "date"
    t.integer "rating"
    t.integer "reps", default: 0, null: false
    t.string "tags"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_activities_on_skill_id"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "practice_items", force: :cascade do |t|
    t.bigint "skill_id", null: false
    t.bigint "practice_list_id", null: false
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["practice_list_id"], name: "index_practice_items_on_practice_list_id"
    t.index ["skill_id"], name: "index_practice_items_on_skill_id"
  end

  create_table "practice_lists", force: :cascade do |t|
    t.bigint "skillsets_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skillsets_id"], name: "index_practice_lists_on_skillsets_id"
    t.index ["user_id"], name: "index_practice_lists_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "name"
    t.string "notes"
    t.string "reason"
    t.text "steps"
    t.string "media"
    t.string "tags"
    t.string "category"
    t.bigint "user_id", null: false
    t.bigint "skillset_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skillset_id"], name: "index_skills_on_skillset_id"
    t.index ["user_id"], name: "index_skills_on_user_id"
  end

  create_table "skillset", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_skillset_on_user_id"
  end

  create_table "skillsets", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_skillsets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "role"
    t.integer "current_skillset"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "activities", "skills"
  add_foreign_key "activities", "users"
  add_foreign_key "practice_items", "practice_lists"
  add_foreign_key "practice_items", "skills"
  add_foreign_key "practice_lists", "skillsets", column: "skillsets_id"
  add_foreign_key "practice_lists", "users"
  add_foreign_key "skills", "skillsets"
  add_foreign_key "skills", "users"
  add_foreign_key "skillset", "users"
  add_foreign_key "skillsets", "users"
end
