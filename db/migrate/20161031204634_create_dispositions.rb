class CreateDispositions < ActiveRecord::Migration
  def up
    create_table :dispositions do |t|
      t.string :disp_code
      t.text :disp_description
      t.timestamps null: false
    end

    add_column :issues, :disposition_id, :integer
    add_foreign_key :issues, :dispositions
  end

  def down
    remove_foreign_key :issues, :dispositions
    remove_column :issues, :disposition_id
    drop_table :dispositions
  end
end
