# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_15_111930) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "openvox_modules", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.string "description", null: false
    t.integer "downloads", default: 0, null: false
    t.datetime "deprecated_at", precision: nil
    t.string "deprecated_for"
    t.string "homepage_url", null: false
    t.string "issues_url", null: false
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "superseded_by_id"
    t.index ["slug"], name: "index_openvox_modules_on_slug", unique: true
    t.index ["superseded_by_id"], name: "index_openvox_modules_on_superseded_by_id"
    t.index ["user_id"], name: "index_openvox_modules_on_user_id"
  end

  create_table "releases", force: :cascade do |t|
    t.bigint "openvox_module_id", null: false
    t.string "slug", null: false
    t.string "version", null: false
    t.integer "downloads"
    t.datetime "deleted_at", precision: nil
    t.string "deleted_for"
    t.integer "file_size", null: false
    t.string "file_md5", null: false
    t.string "file_sha256", null: false
    t.string "readme"
    t.string "changelog"
    t.string "license"
    t.string "reference"
    t.json "metadata", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["openvox_module_id", "version"], name: "index_releases_on_openvox_module_id_and_version", unique: true
    t.index ["openvox_module_id"], name: "index_releases_on_openvox_module_id"
    t.index ["slug"], name: "index_releases_on_slug", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address", null: false
    t.string "user_agent", null: false
    t.boolean "remember_me", default: false, null: false
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.string "username", null: false
    t.string "display_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "openvox_modules", "openvox_modules", column: "superseded_by_id"
  add_foreign_key "openvox_modules", "users"
  add_foreign_key "releases", "openvox_modules"
  add_foreign_key "sessions", "users"
end
