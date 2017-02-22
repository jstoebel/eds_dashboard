class DropAssessmentTables < ActiveRecord::Migration
  def up
    drop_table :student_scores
    drop_table :item_levels
    drop_table :version_habtm_items
    drop_table :assessment_items
    drop_table :assessment_versions
  end

  def down

    # assessment versions
    create_table "assessment_versions", force: :cascade do |t|
      t.string   "slug",          limit: 255
      t.datetime "retired_on"
      t.integer  "assessment_id", limit: 4,   null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index "assessment_versions", ["assessment_id"], name: "fk_rails_69aa91aaac", using: :btree
    add_foreign_key "assessment_versions", "assessments"

    # assessment_items
    create_table "assessment_items", force: :cascade do |t|
      t.string   "slug",        limit: 255
      t.text     "description", limit: 65535
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "name",        limit: 255
    end

    # version_habtm_items
    create_table "version_habtm_items", force: :cascade do |t|
      t.integer  "assessment_version_id", limit: 4, null: false
      t.integer  "assessment_item_id",    limit: 4, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "version_habtm_items", ["assessment_item_id"], name: "fk_rails_5d2c803ddf", using: :btree
    add_index "version_habtm_items", ["assessment_version_id"], name: "fk_rails_c41fee807a", using: :btree
    add_foreign_key "version_habtm_items", "assessment_items"
    add_foreign_key "version_habtm_items", "assessment_versions"

    # item_levels
    create_table "item_levels", force: :cascade do |t|
      t.integer  "assessment_item_id", limit: 4,     null: false
      t.text     "descriptor",         limit: 65535
      t.string   "level",              limit: 255
      t.integer  "ord",                limit: 4
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "cut_score"
    end

    add_foreign_key "item_levels", "assessment_items"

    # student_scores
    create_table "student_scores", force: :cascade do |t|
      t.integer  "student_id",            limit: 4, null: false
      t.integer  "assessment_version_id", limit: 4, null: false
      t.integer  "assessment_item_id",    limit: 4, null: false
      t.integer  "item_level_id",         limit: 4, null: false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "student_scores", ["assessment_item_id"], name: "fk_rails_e8e505d224", using: :btree
    add_index "student_scores", ["assessment_version_id"], name: "fk_rails_2ba42fd723", using: :btree
    add_index "student_scores", ["item_level_id"], name: "fk_rails_30b71fc0a4", using: :btree
    add_index "student_scores", ["student_id"], name: "fk_rails_076846734f", using: :btree

    add_foreign_key "student_scores", "assessment_items"
    add_foreign_key "student_scores", "assessment_versions"
    add_foreign_key "student_scores", "item_levels"
    add_foreign_key "student_scores", "students"

  end
end
