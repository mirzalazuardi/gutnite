class Api::V1::Users::FollowsController < Api::V1::UsersController

  # @summary Follow a user
  # @request_body Follow to be created [!Hash{follow: Hash{followed_user_id: Integer}}]
  def create
    followed_user_id = User.find(params[:follow][:followed_user_id])
    result = FollowUserService.call(current_user, followed_user_id)
    if result.success?
      delete_caches(followed_user_id)
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
      delete_caches(@follow.followed_user_id)

      head :no_content
    else
      render json: { error: "Not following" }, status: :not_found
    end
  end

  # @summary List followings
  # @parameter page(query) [String] Page number for pagination
  def followings
    opts = {page: params[:page]}
    opts[:cache_key] = "user:#{current_user.id}:followings"
    source = Follow.includes(:followed_user).includes([:follower])
      .where(follower_id: current_user.id)
    render_list(source, FollowSerializer, opts)
  end

  # @summary List followers
  # @parameter page(query) [String] Page number for pagination
  def followers
    opts = {page: params[:page], cache_key: "user:#{current_user.id}:followers"}
    source = Follow.includes(:follower).where(followed_user_id: current_user.id).includes([:followed_user])
    render_list(source, FollowSerializer, opts)
  end

  private

    def follow_params
      params.require(:follow).permit(:id, :follower_id, :followed_user_id)
    rescue ActionController::ParameterMissing
      render json: { error: 'Missing follow parameters' }, status: :bad_request
    end

    def delete_caches(followed_user_id)
      Rails.cache.delete("user:#{current_user.id}:followings:*")
      Rails.cache.delete("user:#{followed_user_id}:followers:*")
    end
end
