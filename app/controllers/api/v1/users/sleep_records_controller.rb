class Api::V1::Users::SleepRecordsController < Api::V1::UsersController

  def index
    cache_key = "user:#{@user.id}:following_sleeps:v2:#{I18n.locale}"
    records = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      one_week_ago = 1.week.ago.beginning_of_day
      following_ids = Follow.where(follower: @user).pluck(:followed_user_id)
      next [] if following_ids.blank?

      SleepRecord
        .where(user_id: following_ids)
        .where("went_to_bed_at >= ?", one_week_ago)
        .includes(:user)
        .order("duration DESC")
        .limit(100)
    end

    render json: records, each_serializer: SleepRecordSerializer, status: :ok
  end

  def create
    @sleep_record = @user.sleep_records.new(sleep_record_params)
    if @sleep_record.save
      render json: @sleep_record, serializer: SleepRecordSerializer, status: :created
    else
      render json: {errors: @sleep_record.errors}, status: :unprocessable_entity
    end
  end

  private

    def sleep_record_params
      params.require(:sleep_record)
        .permit(:went_to_bed_at, :woke_up_at)
    rescue ActionController::ParameterMissing
      render json: { error: 'Missing sleep record parameters' }, status: :bad_request
    end
end
