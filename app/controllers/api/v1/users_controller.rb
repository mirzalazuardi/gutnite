class Api::V1::UsersController < ApplicationController
  before_action :set_user

  protected
    def set_user
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :not_found
    end
end
