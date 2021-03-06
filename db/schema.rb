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

ActiveRecord::Schema.define(version: 20131122184929) do

  create_table "cameras", force: true do |t|
    t.string   "name"
    t.string   "host_uri"
    t.string   "capture_path"
    t.string   "username"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "captures", force: true do |t|
    t.integer  "camera_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "time_zone"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "job_id"
    t.string   "pid"
    t.boolean  "recurrent",  default: false
  end

  create_table "schedule_cameras", force: true do |t|
    t.integer "schedule_id"
    t.integer "camera_id"
  end

  create_table "schedules", force: true do |t|
    t.integer  "wday"
    t.time     "start_time"
    t.time     "end_time"
    t.boolean  "enabled",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
