class AddDurationToSleepRecord < ActiveRecord::Migration[8.0]
  def change
    add_column :sleep_records, :duration, :decimal, precision: 5, scale: 2
    add_index :sleep_records, :duration, order: { duration: :desc }
    add_index :sleep_records, [:user_id, :went_to_bed_at]
  end
end
