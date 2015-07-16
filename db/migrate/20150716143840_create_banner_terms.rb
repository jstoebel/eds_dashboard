class CreateBannerTerms < ActiveRecord::Migration
  def change
    create_table :banner_terms do |t|

      t.timestamps
    end
  end
end
