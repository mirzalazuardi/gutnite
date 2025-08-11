class Api::V1::UsersController < ApplicationController
  before_action :set_user, except: [:all]

  # @summary List all users
  def all
    @users = Rails.cache.fetch('users', expires_in: 15.minutes) do
      User.all
    end
    render json: @users, each_serializer: UserSerializer, status: :ok
  end

  protected
    def set_user
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    end

    def current_user
      @current_user ||= User.find_by(id: params[:user_id])
    end
end
