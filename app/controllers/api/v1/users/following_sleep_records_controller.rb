class Api::V1::Users::FollowingSleepRecordsController < Api::V1::UsersController

  def index
    @sleep_records = @user.following_sleep_records.includes(:user)
    render json: @sleep_records, each_serializer: SleepRecordSerializer, status: :ok
  end
end
