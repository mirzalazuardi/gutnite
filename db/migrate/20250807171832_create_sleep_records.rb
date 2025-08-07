class CreateSleepRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :sleep_records do |t|
      t.datetime :went_to_bed
      t.datetime :woke_up_at

      t.timestamps
    end
  end
end
