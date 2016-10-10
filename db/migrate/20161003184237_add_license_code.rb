class AddLicenseCode < ActiveRecord::Migration
  def up
    add_column :programs, :license_code, :string
  end

  def down
    remove_column :programs, :license_code
  end
end
