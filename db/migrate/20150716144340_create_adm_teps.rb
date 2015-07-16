class CreateAdmTeps < ActiveRecord::Migration
  def change
    create_table :adm_teps do |t|

      t.timestamps
    end
  end
end
