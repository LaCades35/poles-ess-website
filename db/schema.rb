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

ActiveRecord::Schema.define(version: 2022_04_26_202346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.string "title"
    t.text "search_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "enabled", default: true
    t.boolean "highlighted", default: false
    t.string "home_title"
    t.string "short_description"
  end

  create_table "adherent_categories", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "adherents", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.integer "position"
    t.boolean "enabled", default: true
    t.integer "adherent_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["adherent_category_id"], name: "index_adherents_on_adherent_category_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "basic_pages", force: :cascade do |t|
    t.string "title"
    t.text "search_description"
    t.integer "position"
    t.boolean "enabled", default: false
    t.string "key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "email_templates", force: :cascade do |t|
    t.text "body"
    t.string "mailer"
    t.string "mail_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "formation_categories", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "enabled", default: true
  end

  create_table "formation_programs", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.boolean "enabled", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "formations", force: :cascade do |t|
    t.string "title"
    t.text "search_description"
    t.integer "formation_category_id"
    t.string "address"
    t.string "zipcode"
    t.string "city"
    t.text "speaker"
    t.integer "tickets_count"
    t.float "cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "enabled", default: true
    t.index ["formation_category_id"], name: "index_formations_on_formation_category_id"
  end

  create_table "key_numbers", force: :cascade do |t|
    t.string "title"
    t.string "number"
    t.string "source"
    t.text "search_description"
    t.integer "position"
    t.boolean "enabled", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "main_pages", force: :cascade do |t|
    t.string "title"
    t.string "baseline"
    t.text "search_description"
    t.integer "position"
    t.boolean "enabled", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_page_id"
    t.string "key"
    t.string "short_description"
    t.index ["parent_page_id"], name: "index_main_pages_on_parent_page_id"
  end

  create_table "menu_blocks", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.integer "main_page_id"
    t.integer "theme_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["main_page_id"], name: "index_menu_blocks_on_main_page_id"
    t.index ["theme_id"], name: "index_menu_blocks_on_theme_id"
  end

  create_table "menu_items", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.integer "position"
    t.integer "menu_block_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["menu_block_id"], name: "index_menu_items_on_menu_block_id"
  end

  create_table "participants", force: :cascade do |t|
    t.integer "subscription_id"
    t.string "firstname"
    t.string "lastname"
    t.string "organization"
    t.string "email"
    t.string "phone"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subscription_id"], name: "index_participants_on_subscription_id"
  end

  create_table "partner_categories", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "partners", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.integer "position"
    t.boolean "enabled", default: true
    t.integer "partner_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["partner_category_id"], name: "index_partners_on_partner_category_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.integer "searchable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "post_categories", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "enabled", default: true
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "search_description"
    t.datetime "published_at"
    t.datetime "expired_at"
    t.integer "post_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "enabled", default: true
    t.index ["post_category_id"], name: "index_posts_on_post_category_id"
  end

  create_table "profile_interfaces", force: :cascade do |t|
    t.integer "profile_id"
    t.string "profilable_type"
    t.integer "profilable_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["profilable_type", "profilable_id"], name: "index_profile_interfaces_on_profilable_type_and_profilable_id"
    t.index ["profile_id"], name: "index_profile_interfaces_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "title"
    t.string "key"
    t.string "baseline"
    t.text "search_description"
    t.integer "position"
    t.boolean "enabled", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "short_description"
  end

  create_table "resources", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.integer "category", default: 0
    t.string "link"
    t.string "resourceable_type"
    t.integer "resourceable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "enabled", default: true
    t.index ["resourceable_type", "resourceable_id"], name: "index_resources_on_resourceable_type_and_resourceable_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.tsrange "time_range"
    t.string "schedulable_type"
    t.integer "schedulable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["schedulable_type", "schedulable_id"], name: "index_schedules_on_schedulable_type_and_schedulable_id"
  end

  create_table "seos", force: :cascade do |t|
    t.string "slug"
    t.string "title"
    t.text "description"
    t.string "seoable_type"
    t.integer "seoable_id"
    t.string "param"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["seoable_type", "seoable_id"], name: "index_seos_on_seoable_type_and_seoable_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["var"], name: "index_settings_on_var", unique: true
  end

  create_table "staff_member_categories", force: :cascade do |t|
    t.string "title"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "staff_members", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.integer "position"
    t.boolean "enabled", default: true
    t.integer "staff_member_category_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["staff_member_category_id"], name: "index_staff_members_on_staff_member_category_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "formation_id"
    t.float "cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "cgu_accepted_at"
    t.index ["formation_id"], name: "index_subscriptions_on_formation_id"
  end

  create_table "theme_interfaces", force: :cascade do |t|
    t.integer "theme_id"
    t.string "themable_type"
    t.integer "themable_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["themable_type", "themable_id"], name: "index_theme_interfaces_on_themable_type_and_themable_id"
    t.index ["theme_id"], name: "index_theme_interfaces_on_theme_id"
  end

  create_table "themes", force: :cascade do |t|
    t.string "title"
    t.string "baseline"
    t.text "search_description"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "enabled", default: true
    t.string "short_description"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
