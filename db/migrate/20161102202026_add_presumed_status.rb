class AddPresumedStatus < ActiveRecord::Migration
  def up
    change_table :students do |t|
      t.string :presumed_status
      t.text :presumed_status_comment
    end
  end

  def down
    change_table :students do |t|
      t.remove :presumed_status
      t.remove :presumed_status_comment
    end
  end
end
