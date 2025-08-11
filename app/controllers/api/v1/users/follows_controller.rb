class Api::V1::Users::FollowsController < Api::V1::UsersController

  # @summary Follow a user
  # @request_body Follow to be created [!Hash{follow: Hash{followed_user_id: Integer}}]
  def create
    followed = User.find(params[:follow][:followed_user_id])
    result = FollowUserService.call(current_user, followed)
    if result.success?
      render json: { message: result.message, id: result.follow_id },
         status: result.status
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  # @summary Unfollow a user
  def destroy
    @follow = Follow.find_by(follower: current_user, id: params[:id])
    if @follow&.destroy
      Rails.cache.delete("user:#{current_user.id}:followings")
      Rails.cache.delete("user:#{@follow.followed_user_id}:followers")

      head :no_content
    else
      render json: { error: "Not following" }, status: :not_found
    end
  end

  # @summary List followings
  def followings
    rows = Rails.cache.fetch("user:#{current_user.id}:followings", expires_in: 15.minutes) do
      Follow.includes(:followed_user).where(follower_id: current_user.id).to_a
    end
    render json: FollowSerializer.new(rows).serialize, status: :ok
  end

  # @summary List followers
  def followers
    rows = Rails.cache.fetch("user:#{current_user.id}:followers", expires_in: 15.minutes) do
      Follow.includes(:follower).where(followed_user_id: current_user.id).to_a
    end
    render json: FollowSerializer.new(rows).serialize, status: :ok
  end

  private

    def follow_params
      params.require(:follow).permit(:id, :follower_id, :followed_user_id)
    rescue ActionController::ParameterMissing
      render json: { error: 'Missing follow parameters' }, status: :bad_request
    end
end
