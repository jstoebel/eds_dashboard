class RemovePgp < ActiveRecord::Migration[5.0]
  def up

    drop_table :pgp_scores
    drop_table :pgps
  end

  def down
    create_table "pgp_scores", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.integer  "pgp_id"
      t.integer  "goal_score"
      t.text     "score_reason", limit: 65535
      t.datetime "created_at"
      t.datetime "updated_at"
      t.index ["pgp_id"], name: "fk_rails_e14b2a6a06", using: :btree
    end

    create_table "pgps", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.integer  "student_id"
      t.string   "goal_name"
      t.text     "description", limit: 65535
      t.text     "plan",        limit: 65535
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "strategies",  limit: 65535
      t.index ["student_id"], name: "fk_rails_4f8f978860", using: :btree
    end

    add_foreign_key "pgp_scores", "pgps"
    add_foreign_key "pgps", "students"
  end
end
