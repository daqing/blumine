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

ActiveRecord::Schema.define(:version => 20110605071315) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "event_name"
    t.integer  "target_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "comments", :force => true do |t|
    t.integer  "issue_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issue_assignments", :force => true do |t|
    t.integer  "issue_id"
    t.integer  "user_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "issues", :force => true do |t|
    t.integer  "project_id"
    t.string   "title"
    t.text     "content"
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "label"
    t.integer  "milestone_id"
    t.date     "planned_date"
  end

  create_table "milestones", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.date     "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todo_items", :force => true do |t|
    t.integer  "issue_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "workflow_state"
    t.integer  "position"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "persistence_token"
    t.string   "locale"
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
