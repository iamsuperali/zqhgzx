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

ActiveRecord::Schema.define(:version => 20130221104105) do

  create_table "categories", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.integer  "order"
    t.integer  "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.integer  "cate"
    t.date     "start_at"
    t.date     "end_at"
    t.integer  "start_node"
    t.integer  "end_node"
    t.integer  "created_by"
    t.integer  "approved_by"
    t.string   "remark"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "links", :force => true do |t|
    t.string   "url"
    t.string   "name"
    t.integer  "order"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "login_logs", :force => true do |t|
    t.integer  "user_id"
    t.string   "ip"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.integer  "org_id"
    t.string   "title"
    t.string   "content"
    t.integer  "comment_status"
    t.integer  "order"
    t.integer  "status"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.integer  "grade"
    t.integer  "subject"
    t.string   "author",         :limit => 20
    t.boolean  "approved",                     :default => false, :null => false
    t.string   "random_mark",    :limit => 8
    t.integer  "hit",                          :default => 0
  end

  create_table "uploads", :force => true do |t|
    t.integer  "post_id"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "random_mark",         :limit => 8
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",                    :default => "", :null => false
    t.string   "user_name",                             :default => "", :null => false
    t.integer  "roles_mask",                            :default => 0,  :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.integer  "approved",                              :default => 0,  :null => false
    t.string   "real_name",              :limit => 20
    t.string   "id_card",                :limit => 18
    t.string   "tel",                    :limit => 30
    t.string   "company",                :limit => 100
    t.integer  "grade"
    t.integer  "org_id"
    t.integer  "subject"
  end

  add_index "users", ["approved"], :name => "index_users_on_approved"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
