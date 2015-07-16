class CreateBannerUpdates < ActiveRecord::Migration
  def change
    create_table :banner_updates do |t|

      t.timestamps
    end
  end
end
