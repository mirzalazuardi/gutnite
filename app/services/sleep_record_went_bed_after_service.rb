class SleepRecordWentBedAfterService
  attr_reader :user, :opts
    def initialize(user, opts = {})
      @user = user
      @opts = opts
    end

    def call
      period = extract_period(opts)
      itself = opts[:include_self] || true
      user_ids = extract_user_ids(user, opts)
      user_ids = user_ids + [user.id] if itself
      user_ids = user_ids.uniq

      return [] if user_ids.blank?

      fetch_sleep_records(user_ids, period)
    end

    private

    def extract_period(opts)
      opts[:period] || 1.week.ago.beginning_of_day
    end

    def extract_user_ids(user, opts)
      case opts[:type]
      when :following
        user.followings.pluck(:id)
      when :followers
        user.followers.pluck(:id)
      else
        []
      end
    end

    def fetch_sleep_records(user_ids, period)
      ::SleepRecord
        .where(user_id: user_ids)
        .where("went_to_bed_at >= ?", period)
        .order("duration DESC")
    end
end
