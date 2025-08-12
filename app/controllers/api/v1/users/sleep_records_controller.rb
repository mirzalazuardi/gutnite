class Api::V1::Users::SleepRecordsController < Api::V1::UsersController

  # @summary List sleep records of the user
  def index
    cache_key = "user:#{@user.id}:sleep_records"
    @sleep_records = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      SleepRecordWentBedAfterService.new(@user, include_self: true).call
    end

    render json: SleepRecordSerializer.new(@sleep_records).serialize, status: :ok
  end

  # @summary create a new sleep record for the user
  # @request_body User sleep record to be created [!Hash{sleep_record: Hash{went_to_bed_at: DateTime, woke_up_at: DateTime}}]
  def create
    @sleep_record = @user.sleep_records.new(sleep_record_params)
    if @sleep_record.save
      render json: SleepRecordSerializer.new(@sleep_record).serialize,
        status: :created
    else
      render json: {errors: @sleep_record.errors}, status: :unprocessable_entity
    end
  end

  # @summary List sleep records of the user's following users
  def followings
    cache_key = "user:#{@user.id}:following_sleeps"
    records = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      SleepRecordWentBedAfterService.new(@user, include_self: true, type: :following).call
    end

    render json: SleepRecordSerializer.new(records, with_traits: :user).serialize,
      status: :ok
  end

  private

    def sleep_record_params
      params.require(:sleep_record)
        .permit(:went_to_bed_at, :woke_up_at)
    rescue ActionController::ParameterMissing
      render json: { error: 'Missing sleep record parameters' },
        status: :bad_request
    end
end
