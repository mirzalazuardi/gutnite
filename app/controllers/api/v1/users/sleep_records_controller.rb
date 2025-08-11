class Api::V1::Users::SleepRecordsController < Api::V1::UsersController

  # @summary List sleep records of the user
  def index
    cache_key = "user:#{@user.id}:sleep_records"
    @sleep_records = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      SleepRecordWentBedAfterService.new(@user, include_self: true).call
    end

    render json: @sleep_records,
      each_serializer: SleepRecordSerializer, status: :ok
  end

  # @summary Show a specific sleep record of the user
  def show
    @sleep_record = @user.sleep_records.find(params[:id])
    render json: @sleep_record, serializer: SleepRecordSerializer, status: :ok
  end

  # @summary create a new sleep record for the user
  # @request_body User sleep record to be created [!Hash{sleep_record: Hash{went_to_bed_at: DateTime, woke_up_at: DateTime}}]
  def create
    @sleep_record = @user.sleep_records.new(sleep_record_params)
    if @sleep_record.save
      render json: @sleep_record,
        serializer: SleepRecordSerializer, status: :created
    else
      render json: {errors: @sleep_record.errors}, status: :unprocessable_entity
    end
  end

  # @summary List sleep records of the user's following users
  def followings
    cache_key = "user:#{@user.id}:following_sleeps"
    records = Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      
    records = SleepRecordWentBedAfterService.new(@user, include_self: true, type: :following).call
      SleepRecordWentBedAfterService.new(@user, include_self: true, type: :following).call
    end

    render json: records, each_serializer: SleepRecordSerializer, status: :ok
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
