# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170122210236) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "time"
    t.string   "place"
    t.string   "purpose"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "time"], name: "index_events_on_user_id_and_time", using: :btree
    t.index ["user_id"], name: "index_events_on_user_id", using: :btree
  end

  create_table "invites", force: :cascade do |t|
    t.integer  "user_group_id"
    t.integer  "recepient_id"
    t.integer  "sender_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "event_id"
    t.boolean  "accept"
    t.index ["recepient_id", "sender_id", "event_id"], name: "index_invites_on_recepient_id_and_sender_id_and_event_id", unique: true, using: :btree
    t.index ["recepient_id"], name: "index_invites_on_recepient_id", using: :btree
    t.index ["sender_id"], name: "index_invites_on_sender_id", using: :btree
    t.index ["user_group_id"], name: "index_invites_on_user_group_id", using: :btree
  end

  create_table "microposts", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "attachment"
    t.index ["event_id"], name: "index_microposts_on_event_id", using: :btree
    t.index ["user_id", "created_at", "event_id"], name: "index_microposts_on_user_id_and_created_at_and_event_id", using: :btree
    t.index ["user_id"], name: "index_microposts_on_user_id", using: :btree
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "user_groups", force: :cascade do |t|
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_user_groups_on_event_id", using: :btree
  end

  create_table "user_groups_users", id: false, force: :cascade do |t|
    t.integer "user_group_id"
    t.integer "user_id"
    t.index ["user_group_id"], name: "index_user_groups_users_on_user_group_id", using: :btree
    t.index ["user_id"], name: "index_user_groups_users_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "authentication_token"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "events", "users"
  add_foreign_key "invites", "user_groups"
  add_foreign_key "microposts", "events"
  add_foreign_key "microposts", "users"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "user_groups", "events"
end
