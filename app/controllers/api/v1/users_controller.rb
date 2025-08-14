class Api::V1::UsersController < ApplicationController
  before_action :set_user, except: [:all]

  # @summary List all users
  # @parameter page(query) [String] Page number for pagination
  def all
    opts = { page: params[:page], cache_key: "users"}
    source =  User.all
    render_list(source, UserSerializer, opts)
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
