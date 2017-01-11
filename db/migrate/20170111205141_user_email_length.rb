class UserEmailLength < ActiveRecord::Migration
  def up

    change_column :users, :Email, :string, :limit => 100
  end

  def down
    change_column :users, :Email, :string, :limit => 45
  end
end
