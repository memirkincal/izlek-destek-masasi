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

ActiveRecord::Schema[8.1].define(version: 2026_10_26_100000) do
  create_table "knowledge_articles", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.string "locale", null: false
    t.string "source_key", null: false
    t.string "title", null: false
    t.text "terms", null: false
    t.text "body", null: false
    t.text "reply", null: false
    t.boolean "published", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "locale", "source_key"], name: "index_knowledge_articles_on_workspace_locale_source", unique: true
    t.index ["organization_id"], name: "index_knowledge_articles_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "replies", force: :cascade do |t|
    t.integer "ticket_id", null: false
    t.string "author_name", null: false
    t.text "body", null: false
    t.boolean "internal", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["ticket_id"], name: "index_replies_on_ticket_id"
    t.index ["user_id"], name: "index_replies_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "requester_name", null: false
    t.string "requester_email", null: false
    t.string "subject", null: false
    t.text "description", null: false
    t.string "status", default: "new", null: false
    t.string "priority", default: "normal", null: false
    t.string "assignee"
    t.datetime "first_response_at"
    t.datetime "solved_at"
    t.datetime "response_due_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organization_id"
    t.integer "requester_user_id"
    t.integer "assignee_user_id"
    t.index ["assignee_user_id"], name: "index_tickets_on_assignee_user_id"
    t.index ["organization_id"], name: "index_tickets_on_organization_id"
    t.index ["requester_user_id"], name: "index_tickets_on_requester_user_id"
    t.index ["response_due_at"], name: "index_tickets_on_response_due_at"
    t.index ["status"], name: "index_tickets_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: "", null: false
    t.string "role", default: "requester", null: false
    t.integer "organization_id"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "knowledge_articles", "organizations"
  add_foreign_key "replies", "tickets"
  add_foreign_key "replies", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "tickets", "organizations"
  add_foreign_key "tickets", "users", column: "assignee_user_id"
  add_foreign_key "tickets", "users", column: "requester_user_id"
  add_foreign_key "users", "organizations"
end
