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

ActiveRecord::Schema.define(version: 20190626153436) do

  create_table "inboxes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_inboxes_on_user_id", using: :btree
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "body",       limit: 65535
    t.integer  "outbox_id"
    t.integer  "inbox_id"
    t.boolean  "read",                     default: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["inbox_id"], name: "index_messages_on_inbox_id", using: :btree
    t.index ["outbox_id"], name: "index_messages_on_outbox_id", using: :btree
  end

  create_table "outboxes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_outboxes_on_user_id", using: :btree
  end

  create_table "payments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_payments_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "is_patient", default: true
    t.boolean  "is_doctor",  default: false
    t.boolean  "is_admin",   default: false
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

end
