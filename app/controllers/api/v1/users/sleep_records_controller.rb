class Api::V1::Users::SleepRecordsController < Api::V1::UsersController

  # @summary List sleep records of the user
  # @parameter page(query) [String] Page number for pagination
  def index
    opts = { page: params[:page], cache_key: "user:#{@user.id}:sleep_records"}
    source = SleepRecordWentBedAfterService.new(current_user).call
    render_list(source, SleepRecordSerializer, opts)
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
  # @parameter page(query) [String] Page number for pagination
  def followings
    opts = { page: params[:page], cache_key: "user:#{@user.id}:following_sleeps" }
    source = SleepRecordWentBedAfterService
      .new(current_user, type: :following).call.includes([:user])
    render_list(source, SleepRecordSerializer, opts, {with_traits: :user})
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
