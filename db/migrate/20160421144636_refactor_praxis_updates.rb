class RefactorPraxisUpdates < ActiveRecord::Migration
  def up
    #let's just drop and rebuild from scratch

    drop_table :praxis_updates

    create_table :praxis_updates do |t|
      t.datetime :report_date
      t.timestamps
    end

  end

  def down
    drop_table :praxis_updates

    create_table :praxis_updates, :primary_key => "ReportDate" do |t|
      t.datetime :UploadDate, :null => false
    end

    change_column :praxis_updates, :ReportDate, :datetime

  end
end
