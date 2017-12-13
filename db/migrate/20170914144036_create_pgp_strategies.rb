class CreatePgpStrategies < ActiveRecord::Migration[5.0]
  def up
    create_table :pgp_strategies do |t|
      t.references :pgp_goal
      t.string :name
      t.text :timeline
      t.text :resources
      t.boolean :active
      t.timestamps
    end

    add_foreign_key :pgp_strategies, :pgp_goals
  end

  def down
    remove_foreign_key :pgp_strategies, :pgp_goals
    drop_table :pgp_strategies
  end
end
