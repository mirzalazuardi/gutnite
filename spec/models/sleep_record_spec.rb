require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
  end

  context 'validations' do
    let(:user) { create(:user) }
    let(:sleep_record) { SleepRecord.new(user: user, went_to_bed_at: Time.current, woke_up_at: Time.current + 8.hours) }

    it 'is valid with valid attributes' do
      expect(sleep_record).to be_valid
    end

    it 'is not valid without a user' do
      sleep_record.user = nil
      expect(sleep_record).not_to be_valid
      expect(sleep_record.errors[:user]).to include("must exist")
    end

    it 'is not valid without a went to bed at' do
      sleep_record.went_to_bed_at = nil
      expect(sleep_record).not_to be_valid
      expect(sleep_record.errors[:went_to_bed_at]).to include("can't be blank")
    end

    it 'is not valid without an woke up at' do
      sleep_record.woke_up_at = nil
      expect(sleep_record).not_to be_valid
      expect(sleep_record.errors[:woke_up_at]).to include("can't be blank")
    end

    it 'is not valid if start time is after end time' do
      sleep_record.went_to_bed_at = Time.current + 1.hour
      sleep_record.woke_up_at = Time.current
      expect(sleep_record).not_to be_valid
      expect(sleep_record.errors[:base]).to include("Went to bed must be before Woke up at")
    end
  end
end
