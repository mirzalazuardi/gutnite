class Api::V1::Users::FollowsController < Api::V1::UsersController

  def create
    followed = User.find(params[:followed_user_id])
    @follow = Follow.find_or_initialize_by(
      follower: @user,
      followed_user: followed
    )

    if @follow.new_record? && @follow.save
      render json: { message: "Successfully followed" }, serializer: FollowSerializer, status: :created
    elsif !@follow.new_record?
      render json: { message: "Already following" }, serializer: FollowSerializer, status: :ok
    else
      render json: { errors: @follow.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    followed = User.find(params[:id])
    @follow = Follow.find_by(follower: @user, followed_user: followed)
    if @follow&.destroy
      head :no_content
    else
      render json: { error: "Not following" }, status: :not_found
    end
  end

  private

    def follow_params
      params.require(:follow).permit(:follower_id, :followed_user_id)
    end
end
