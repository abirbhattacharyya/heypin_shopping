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

ActiveRecord::Schema.define(:version => 20120822101810) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.string   "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "user_id"
    t.string   "prodcut_id"
    t.string   "email"
    t.float    "price"
    t.string   "transaction_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "postal_code"
    t.string   "phone_number"
    t.string   "card_type"
    t.integer  "card_number",     :limit => 8
    t.integer  "cc_expiry_month"
    t.integer  "cc_expiry_year"
    t.integer  "status",                       :default => 0
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "product_images", :force => true do |t|
    t.integer  "product_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "product_likes", :force => true do |t|
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "products", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "name"
    t.text     "description"
    t.float    "price"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "website"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "name"
    t.string   "fb_uid"
  end

end
