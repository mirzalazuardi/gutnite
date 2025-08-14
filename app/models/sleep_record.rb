class SleepRecord < ApplicationRecord
  belongs_to :user
  validates :user, :went_to_bed_at, :woke_up_at, presence: true

  before_validation :calculate_duration
  validate :went_to_bed_at_before_woke_up_at

  def calculate_duration
    self.duration = (woke_up_at - went_to_bed_at) / 3600.0 if went_to_bed_at && woke_up_at
  end

  def went_to_bed_at_before_woke_up_at
    if went_to_bed_at && woke_up_at && went_to_bed_at >= woke_up_at
      errors.add(:base, "Went to bed must be before Woke up at")
    end
  end
end
