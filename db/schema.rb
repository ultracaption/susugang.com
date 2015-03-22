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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121128190759) do

  create_table "assessments", :force => true do |t|
    t.integer  "lecture_id"
    t.integer  "user_id"
    t.float    "overall_score"
    t.integer  "presentation_score"
    t.integer  "difficulty_score"
    t.integer  "grading_score"
    t.text     "content"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "title"
    t.string   "provider"
    t.string   "category"
    t.boolean  "is_major"
    t.string   "misc_items"
    t.integer  "upvote_count",       :default => 0
    t.integer  "downvote_count",     :default => 0
    t.integer  "hit_count",          :default => 0
    t.integer  "comment_count",      :default => 0
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "assessment_id"
    t.integer  "parent_id"
    t.text     "content"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "lectures", :force => true do |t|
    t.string   "title"
    t.string   "category"
    t.string   "department"
    t.string   "provider"
    t.string   "extra"
    t.integer  "upvote_count"
    t.integer  "downvote_count"
    t.integer  "assessment_count"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "hit_count"
    t.float    "overall_score"
    t.float    "presentation_score"
    t.float    "difficulty_score"
    t.float    "grading_score"
  end

  create_table "pre_registrations", :force => true do |t|
    t.string   "mobile_contact"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "registrations", :force => true do |t|
    t.integer  "step"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "transaction_id"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "lecture_id"
    t.integer  "user_id"
    t.integer  "coord_x"
    t.integer  "coord_y"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "nickname"
    t.integer  "transaction_id"
    t.integer  "assessment_count"
    t.string   "username"
    t.string   "department"
    t.string   "student_id"
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "assessment_id"
    t.boolean  "positive"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
