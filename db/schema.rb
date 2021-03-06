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

ActiveRecord::Schema.define(version: 20140608054812) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "raw_pages", force: true do |t|
    t.string   "url"
    t.text     "html"
    t.string   "category"
    t.boolean  "is_parsed",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "raw_pages", ["category"], name: "index_raw_pages_on_category", using: :btree

  create_table "views", force: true do |t|
    t.string   "url"
    t.text     "description"
    t.string   "location"
    t.string   "picture_url"
    t.datetime "posted_at"
    t.integer  "seconds_since_midnight"
    t.decimal  "lat",                    precision: 9, scale: 6
    t.decimal  "lon",                    precision: 9, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "geocode_json"
    t.string   "display_name"
    t.string   "image"
  end

end
