class CreateTranscripts < ActiveRecord::Migration
  def change
    create_table :transcripts do |t|

      t.timestamps
    end
  end
end
