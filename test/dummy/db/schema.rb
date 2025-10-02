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

ActiveRecord::Schema[7.2].define(version: 2024_01_01_000000) do
  create_table "reported_reports", force: :cascade do |t|
    t.string "document_uri"
    t.string "violated_directive"
    t.string "blocked_uri"
    t.text "original_policy"
    t.json "raw_report", default: {}, null: false
    t.datetime "notified_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_reported_reports_on_created_at"
    t.index ["notified_at"], name: "index_reported_reports_on_notified_at"
  end
end
