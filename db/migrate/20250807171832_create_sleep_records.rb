class CreateSleepRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :went_to_bed_at
      t.datetime :woke_up_at

      t.timestamps
    end
  end
end
