class AdmStTimestamps < ActiveRecord::Migration
  def up
      add_column :adm_st, :created_at, :datetime
      add_column :adm_st, :updated_at, :datetime
  end

  def down
    remove_column :adm_st, :created_at
    remove_column :adm_st, :updated_at
  end
end
