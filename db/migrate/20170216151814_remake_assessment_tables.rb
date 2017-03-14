class RemakeAssessmentTables < ActiveRecord::Migration
    def up
        create_table "assessment_items", force: :cascade do |t|
          t.references "assessment"
          t.string   "name",        limit: 255
          t.string   "slug",        limit: 255
          t.text     "description", limit: 65535
          t.datetime "created_at"
          t.datetime "updated_at"
        end

        add_index :assessment_items, :assessment_id

        create_table "item_levels", force: :cascade do |t|
          t.references "assessment_item"
          t.text     "descriptor",         limit: 65535
          t.string   "level",              limit: 255
          t.integer  "ord",                limit: 4
          t.datetime "created_at"
          t.datetime "updated_at"
          t.boolean  "cut_score"
        end


        add_index :item_levels, :assessment_item_id

        create_table "student_scores", force: :cascade do |t|
          t.references "student"
          t.references "item_level"
          t.datetime "created_at"
          t.datetime "updated_at"
        end

        [:student, :item_level].each do |col|
            add_index :student_scores, "#{col}_id"
        end
    end

    def down
      drop_table :student_scores
      drop_table :item_levels
      drop_table :assessment_items
    end
end
