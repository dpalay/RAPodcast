# This file is auto-generated from the current state of the database. Instead of editing this file,
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 24) do

  create_table "links", :force => true do |t|
    t.string   "url"
    t.integer  "user_id",                  :default => 0
    t.string   "title",      :limit => 60
    t.boolean  "from_admin",               :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "postset_id"
    t.boolean  "used"
  end

  create_table "miscs", :force => true do |t|
    t.text     "content"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "postset_id"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  create_table "postsets", :force => true do |t|
    t.datetime "created_at"
    t.string   "podcast_link"
    t.string   "shownotes_link"
    t.string   "title"
    t.boolean  "published"
    t.string   "random_topic"
    t.text     "content"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "password"
    t.boolean  "gender"
    t.datetime "birthdate"
    t.string   "span"
    t.boolean  "is_admin"
    t.string   "screen_name"
    t.boolean  "is_active"
    t.string   "authorization_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
