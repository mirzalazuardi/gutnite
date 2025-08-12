require 'rails_helper'

RSpec.describe "SleepRecords", type: :request do
  before(:all) do
    create_list(:user, 5)
  end
  let(:sleep_hours) { 8 }
  let(:user) { create(:user) }
  let(:init_sleep) { build(:sleep_record, :with_to_bed_at_a_week_ago, user: user) }
  let(:valid_params) do
    {
      sleep_record: init_sleep.as_json.slice('went_to_bed_at', 'woke_up_at', 'user_id')
    }
  end
  before do
    init_sleep.woke_up_at = init_sleep.went_to_bed_at + sleep_hours.hours
  end

  describe "GET /api/v1/users/:user_id/sleep_records" do
    context "when fetching sleep records successfully" do
      before do
        post api_v1_users_sleep_records_path(user_id: user.id), params: valid_params
        get api_v1_users_sleep_records_path(user_id: user.id)
      end

      it "returns a list of sleep records" do
        expect(response).to have_http_status(:ok)
        expect(json_response).to be_an(Array)
        expect(json_response.first['id']).to be_present
      end

      it "returns the correct attributes" do
        expect(json_response.first['went_to_bed_at']).to eq(init_sleep.went_to_bed_at.to_s)
        expect(json_response.first['woke_up_at']).to eq(init_sleep.woke_up_at.to_s)
        expect(json_response.first['duration']).to eq(sleep_hours.to_f.to_s)
      end
    end
  end
      
  describe "POST /api/v1/users/:user_id/sleep_records" do
    before do
      post api_v1_users_sleep_records_path(user_id: user.id), params: valid_params
    end

    context "when creating a sleep record successfully" do
      it "creates a sleep record" do
        expect(response).to have_http_status(:created)
        expect(json_response['id']).to be_present
      end

      it "same diff duration" do
        expect(json_response['duration']).to eq(sleep_hours.to_f.to_s)
      end
    end
  end

  describe "GET /api/v1/users/:user_id/sleep_records/followings" do
    let(:followed_user) { User.last }
    let!(:follow) { FollowUserService.new(user, followed_user).call }
    let(:followed_sleep_record) do
      init = build(:sleep_record, :with_to_bed_at_a_week_ago)
      init.user = followed_user
      init.woke_up_at = init.went_to_bed_at + sleep_hours.hours
      init.save
      init
    end

    before do
      followed_sleep_record
      post api_v1_users_sleep_records_path(user_id: followed_user.id), params: valid_params
      get followings_api_v1_users_sleep_records_path(user_id: user.id)
    end

    context "when fetching sleep records of following users" do
      it "returns a list of sleep records" do
        expect(response).to have_http_status(:ok)
        expect(json_response).to be_an(Array)
        expect(json_response.first['id']).to eq(followed_sleep_record.id)
      end

      it "includes user details in the response" do
        expect(json_response.first['user']['id']).to eq(followed_user.id)
        expect(json_response.first['user']['name']).to eq(followed_user.name)
      end

      it "have 2 sleep records" do
        expect(json_response.size).to eq(2) # includes the user's own sleep record
      end
    end
  end
    
      
end
