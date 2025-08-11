class Api::V1::Users::FollowsController < Api::V1::UsersController

  # @summary Follow a user
  # @request_body Follow to be created [!Hash{follow: Hash{followed_user_id: Integer}}]
  def create
    followed = User.find(params[:follow][:followed_user_id])
    result = FollowUserService.call(current_user, followed)
    if result.success?
      render json: { message: result.message }, serializer: FollowSerializer, status: result.status
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    followed = User.find(params[:id])
    @follow = Follow.find_by(follower: current_user, followed_user: followed)
    if @follow&.destroy
      head :no_content
    else
      render json: { error: "Not following" }, status: :not_found
    end
  end

  private

    def follow_params
      params.require(:follow).permit(:id, :follower_id, :followed_user_id)
    end
end
