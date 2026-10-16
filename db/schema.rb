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

ActiveRecord::Schema[8.1].define(version: 2026_10_16_130100) do
  create_table "replies", force: :cascade do |t|
    t.integer "ticket_id", null: false
    t.string "author_name", null: false
    t.text "body", null: false
    t.boolean "internal", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_replies_on_ticket_id"
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
    t.index ["response_due_at"], name: "index_tickets_on_response_due_at"
    t.index ["status"], name: "index_tickets_on_status"
  end

  add_foreign_key "replies", "tickets"
end
