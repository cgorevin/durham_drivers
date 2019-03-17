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

ActiveRecord::Schema.define(version: 2019_03_17_151028) do

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "contact_histories", force: :cascade do |t|
    t.integer "contact_id"
    t.integer "relief_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contact_histories_on_contact_id"
    t.index ["relief_message_id"], name: "index_contact_histories_on_relief_message_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "relief_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "requestor_name"
    t.string "email"
    t.string "phone"
    t.string "full_name"
    t.string "advice_method"
    t.date "queue_date"
    t.string "street"
    t.string "city"
    t.string "state"
    t.string "zip"
  end

  create_table "contacts_offenses", force: :cascade do |t|
    t.integer "contact_id"
    t.integer "offense_id"
    t.index ["contact_id"], name: "index_contacts_offenses_on_contact_id"
    t.index ["offense_id"], name: "index_contacts_offenses_on_offense_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "offenses", force: :cascade do |t|
    t.boolean "ftp"
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.date "date_of_birth"
    t.date "disposition_date"
    t.string "status"
    t.string "group"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "street_address"
    t.string "city"
    t.string "race"
    t.string "sex"
    t.string "case_number"
    t.text "description"
    t.integer "relief_amount"
    t.index ["date_of_birth"], name: "index_offenses_on_date_of_birth"
    t.index ["first_name", "middle_name", "last_name"], name: "index_offenses_on_first_name_and_middle_name_and_last_name"
    t.index ["group"], name: "index_offenses_on_group"
  end

  create_table "offenses_relief_messages", force: :cascade do |t|
    t.integer "offense_id"
    t.integer "relief_message_id"
    t.index ["offense_id"], name: "index_offenses_relief_messages_on_offense_id"
    t.index ["relief_message_id"], name: "index_offenses_relief_messages_on_relief_message_id"
  end

  create_table "relief_messages", force: :cascade do |t|
    t.integer "contact_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.boolean "new", default: true
    t.index ["contact_id"], name: "index_relief_messages_on_contact_id"
    t.index ["token"], name: "index_relief_messages_on_token"
  end

  create_table "search_histories", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.date "date_of_birth"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
