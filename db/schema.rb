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

ActiveRecord::Schema.define(version: 20150504134030) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bans", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "followers", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "followers", ["followed_id"], name: "index_followers_on_followed_id", using: :btree
  add_index "followers", ["follower_id", "followed_id"], name: "index_followers_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "followers", ["follower_id"], name: "index_followers_on_follower_id", using: :btree

  create_table "grouprels", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "grouprels", ["user_id", "group_id"], name: "index_grouprels_on_user_id_and_group_id", unique: true, using: :btree

  create_table "groups", force: true do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "admin"
    t.boolean  "open",        default: true
  end

  add_index "groups", ["name"], name: "index_groups_on_name", unique: true, using: :btree

  create_table "hashrelations", force: true do |t|
    t.integer  "tweet_id"
    t.integer  "hashtag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "hashrelations", ["tweet_id", "hashtag_id"], name: "index_hashrelations_on_tweet_id_and_hashtag_id", unique: true, using: :btree

  create_table "hashtags", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suggesteds", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "owner"
  end

  create_table "tweets", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "picture"
    t.integer  "group"
    t.integer  "original_tweet_id"
  end

  add_index "tweets", ["user_id", "created_at"], name: "index_tweets_on_user_id_and_created_at", using: :btree
  add_index "tweets", ["user_id"], name: "index_tweets_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",             default: false
    t.string   "confirmation_code"
    t.boolean  "activated"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
