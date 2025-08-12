class SleepRecordSerializer
  include Alba::Resource
  attributes :id, :went_to_bed_at, :woke_up_at, :duration, :created_at, :updated_at
  trait :user do
    attribute :user do |record|
      {
        id: record.user.id,
        name: record.user.name
      }
    end
  end
end
