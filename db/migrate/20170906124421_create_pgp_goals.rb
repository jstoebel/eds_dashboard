class CreatePgpGoals < ActiveRecord::Migration[5.0]
  def up
    create_table :pgp_goals do |t|
      t.references :student
      t.string :name
      t.string :domain
      t.boolean :active

      t.timestamps
    end

    add_foreign_key :pgp_goals, :students
  end

  def down
    remove_foreign_key :pgp_goals, :students
    drop_table :pgp_goals
  end
end
