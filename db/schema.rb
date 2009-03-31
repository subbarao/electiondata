# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090330141553) do

  create_table "candidate_results", :force => true do |t|
    t.integer  "constituency_id"
    t.integer  "year"
    t.integer  "total_votes"
    t.float    "turnout"
    t.string   "winner"
    t.string   "winning_party"
    t.float    "winning_percentage"
    t.string   "runnerup"
    t.string   "runnerup_party"
    t.float    "runnerup_percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "constituencies", :force => true do |t|
    t.string   "name"
    t.string   "district"
    t.string   "ec_id"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat"
    t.float    "lng"
    t.float    "distance"
  end

  create_table "districts", :force => true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lng"
    t.float    "distance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nominations", :force => true do |t|
    t.string   "name"
    t.integer  "party_id"
    t.integer  "seat_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parties", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "party_results", :force => true do |t|
    t.integer  "constituency_id"
    t.string   "name"
    t.float    "percentage"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", :force => true do |t|
    t.string   "name"
    t.integer  "party_id"
    t.integer  "constituency_id"
    t.integer  "votes"
    t.float    "percentage"
    t.integer  "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seats", :force => true do |t|
    t.string   "name"
    t.integer  "district_id"
    t.float    "lat"
    t.float    "lng"
    t.float    "distance"
    t.string   "locality"
    t.string   "type"
    t.integer  "phase"
    t.date     "election_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
