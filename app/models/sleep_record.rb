class SleepRecord < ApplicationRecord
  after_create_commit { Rails.cache.delete_matched("user:*:following_sleeps:*") }

  before_validation :calculate_duration

  def calculate_duration
    self.duration = (woke_up_at - went_to_bed_at) / 3600.0 if went_to_bed_at && woke_up_at
  end
end
