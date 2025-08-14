require 'rails_helper'

RSpec.describe Follow, type: :model do
  context 'validations' do
    let(:user) { create(:user) }
    let(:followed_user) { create(:user) }
    let(:follow) { Follow.new(follower: user, followed_user: followed_user) }

    it 'is valid with valid attributes' do
      expect(follow).to be_valid
    end

    it 'is not valid without a follower' do
      follow.follower = nil
      expect(follow).not_to be_valid
      expect(follow.errors[:follower_id]).to include("can't be blank")
    end

    it 'is not valid without a followed user' do
      follow.followed_user = nil
      expect(follow).not_to be_valid
      expect(follow.errors[:followed_user_id]).to include("can't be blank")
    end

    it 'is not valid if the follower is the same as the followed user' do
      follow.followed_user = user
      expect(follow).not_to be_valid
      expect(follow.errors[:followed_user_id]).to include("You cannot follow yourself")
    end

    it 'is not valid if the follower already follows the followed user' do
      Follow.create(follower: user, followed_user: followed_user)
      expect(follow).not_to be_valid
      expect(follow.errors[:follower_id]).to include("You are already following this user")
    end
  end
end
