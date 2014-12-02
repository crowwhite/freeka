# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141126060310) do

  create_table "addresses", force: true do |t|
    t.string   "street"
    t.string   "city"
    t.string   "pin_code"
    t.string   "state_code"
    t.string   "country_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.boolean  "enabled",    default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree

  create_table "category_requirements", force: true do |t|
    t.integer  "category_id"
    t.integer  "requirement_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_requirements", ["category_id"], name: "index_category_requirements_on_category_id", using: :btree
  add_index "category_requirements", ["requirement_id"], name: "index_category_requirements_on_requirement_id", using: :btree

  create_table "donor_requirements", force: true do |t|
    t.integer  "donor_id",                   null: false
    t.integer  "requirement_id",             null: false
    t.integer  "status",         default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "donor_requirements", ["donor_id"], name: "index_donor_requirements_on_donor_id", using: :btree
  add_index "donor_requirements", ["requirement_id"], name: "index_donor_requirements_on_requirement_id", using: :btree

  create_table "people", force: true do |t|
    t.string   "email",                  default: "",     null: false
    t.string   "encrypted_password",     default: "",     null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,      null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   default: ""
    t.text     "about_me"
    t.string   "contact_no"
    t.text     "address"
    t.string   "type",                   default: "User"
    t.boolean  "enabled",                default: true,   null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree
  add_index "people", ["name"], name: "index_people_on_name", using: :btree
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree

  create_table "requirements", force: true do |t|
    t.string   "title"
    t.text     "details"
    t.date     "expiration_date"
    t.integer  "location_id"
    t.integer  "requestor_id"
    t.integer  "status",          default: 0,    null: false
    t.boolean  "enabled",         default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "delta",           default: true, null: false
  end

end
