require 'rails_helper'

RSpec.describe "Follows", type: :request do
  before(:all) do
    create_list(:user, 5)
  end

  let(:user) { User.first }

  describe "POST /api/v1/users/user_id/follows" do
    let(:followed_user) { User.second }
    let(:valid_params) do
      { follow: { followed_user_id: followed_user.id } }
    end

    context "when user Successfully follows another user" do
      it "creates a follow" do
        post api_v1_users_follows_path(user_id: user&.id), params: valid_params
        expect(response).to have_http_status(:created)
        expect(json_response['message']).to eq("Successfully followed")
        expect(json_response['id']).to be_present
        expect(Follow.where(follower: user, followed_user: followed_user).count).to eq(1)
      end
    end

    context "when user tries to follow themselves" do
      let(:valid_params) do
        { follow: { followed_user_id: user.id } }
      end
      before do
        post api_v1_users_follows_path(user_id: user&.id), params: valid_params
      end

      it "returns an error" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Followed user You cannot follow yourself")
      end
    end

    context "when user tries to follow a user they already follow" do
      before do
        Follow.create(follower: user, followed_user: followed_user)
        post api_v1_users_follows_path(user_id: user&.id), params: valid_params
      end
      it "returns an error" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Already following")
      end
    end
  end

  describe "DELETE /api/v1/users/user_id/follows/:id" do
    let(:followed_user) { User.second }
    let!(:follow) { Follow.create(follower: user, followed_user: followed_user) }

    context "when user unfollows a user" do
      before do
        delete api_v1_users_follow_path(user_id: user&.id, id: follow.id)
      end

      it "deletes the follow" do
        expect(response).to have_http_status(:no_content)
        expect(Follow.exists?(follow.id)).to be false
      end

      it "clears the cache for followings and followers" do
        expect(Rails.cache.exist?("user:#{user.id}:followings")).to be false
        expect(Rails.cache.exist?("user:#{followed_user.id}:followers")).to be false
      end
    end

    context "when trying to unfollow a user not being followed" do
      before do
        delete api_v1_users_follow_path(user_id: user&.id, id: 9999)
      end

      it "returns not found" do
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq("Not following")
      end
    end
  end

  describe "GET /api/v1/users/user_id/follows/followings" do
    before do
      Follow.create(follower: user, followed_user: User.second)
      Follow.create(follower: user, followed_user: User.third)
      get api_v1_users_followings_path(user_id: user&.id)
    end

    it "returns the followings" do
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(2)
      expect(json_response.first['followed_user_id']).to eq(User.second.id)
    end
  end

  describe "GET /api/v1/users/user_id/follows/followers" do
    before do
      Follow.create(follower: User.second, followed_user: user)
      Follow.create(follower: User.third, followed_user: user)
      get api_v1_users_followers_path(user_id: user&.id)
    end

    it "returns the followers" do
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(2)
      expect(json_response.first['follower_id']).to eq(User.second.id)
    end
  end

end
