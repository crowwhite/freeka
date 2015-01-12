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

ActiveRecord::Schema.define(version: 20150112062105) do

  create_table "attachments", force: true do |t|
    t.integer  "attacheable_id"
    t.string   "attacheable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "attacheable_sub_type",    default: "File"
    t.string   "caption",                 default: "No caption available", null: false
  end

  add_index "attachments", ["attacheable_id"], name: "index_attachments_on_attacheable_id", using: :btree
  add_index "attachments", ["attacheable_sub_type"], name: "index_attachments_on_attacheable_sub_type", using: :btree
  add_index "attachments", ["attacheable_type", "attacheable_id"], name: "index_attachments_on_attacheable_type_and_attacheable_id", using: :btree
  add_index "attachments", ["attacheable_type"], name: "index_attachments_on_attacheable_type", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",    default: true, null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree

  create_table "category_requirements", force: true do |t|
    t.integer  "category_id"
    t.integer  "requirement_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "category_requirements", ["category_id"], name: "index_category_requirements_on_category_id", using: :btree
  add_index "category_requirements", ["requirement_id"], name: "index_category_requirements_on_requirement_id", using: :btree

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "requirement_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["requirement_id"], name: "index_comments_on_requirement_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donor_requirements", force: true do |t|
    t.integer  "donor_id",                   null: false
    t.integer  "requirement_id",             null: false
    t.integer  "status",         default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "donor_requirements", ["donor_id"], name: "index_donor_requirements_on_donor_id", using: :btree
  add_index "donor_requirements", ["requirement_id"], name: "index_donor_requirements_on_requirement_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

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
    t.string   "type",                   default: "User"
    t.string   "name",                   default: ""
    t.text     "about_me"
    t.text     "address"
    t.boolean  "enabled",                default: true,   null: false
    t.string   "contact_no"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "slug"
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree
  add_index "people", ["enabled"], name: "index_people_on_enabled", using: :btree
  add_index "people", ["name"], name: "index_people_on_name", using: :btree
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree
  add_index "people", ["slug"], name: "index_people_on_slug", using: :btree
  add_index "people", ["type"], name: "index_people_on_type", using: :btree

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
    t.string   "slug"
    t.string   "street",          default: "",   null: false
    t.string   "city",            default: "",   null: false
    t.string   "country_code",    default: "",   null: false
    t.string   "state_code",      default: "",   null: false
  end

  add_index "requirements", ["requestor_id"], name: "index_requirements_on_requestor_id", using: :btree
  add_index "requirements", ["slug"], name: "index_requirements_on_slug", using: :btree

end
