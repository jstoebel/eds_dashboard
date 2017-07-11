class CreateNotices < ActiveRecord::Migration[5.0]
  def up
    create_table :notices do |t|
      t.text :message, :null => false
      t.boolean :active, :null => false
      t.timestamps
    end
  end
  
  def down
    drop_table :notices
  end
end
