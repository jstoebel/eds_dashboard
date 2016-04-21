class RefactorBannerUpdates < ActiveRecord::Migration
  def up
    drop_table :banner_updates

    create_table :banner_updates do |t|
        t.datetime :upload_date
        t.timestamps
    end
  end

  def down
    drop_table :banner_updates

    create_table "banner_updates", primary_key: "UploadDate", force: true do |t|
    end

  end
end
