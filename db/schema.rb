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

ActiveRecord::Schema.define(version: 2019_01_10_151513) do

  create_table "contact_histories", force: :cascade do |t|
    t.integer "contact_id"
    t.integer "offense_id"
    t.integer "relief_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contact_histories_on_contact_id"
    t.index ["offense_id"], name: "index_contact_histories_on_offense_id"
    t.index ["relief_message_id"], name: "index_contact_histories_on_relief_message_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "type"
    t.string "info"
    t.integer "offense_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offense_id"], name: "index_contacts_on_offense_id"
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
  end

  create_table "relief_messages", force: :cascade do |t|
    t.integer "contact_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_relief_messages_on_contact_id"
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
