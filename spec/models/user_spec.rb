require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { should have_many(:follows).with_foreign_key(:follower_id) }
    it { should have_many(:followings).through(:follows).source(:followed_user) }
    it { should have_many(:inverse_follows).class_name('Follow').with_foreign_key(:followed_user_id) }
    it { should have_many(:followers).through(:inverse_follows).source(:follower) }
  end

  context 'validations' do
    it 'is valid with a unique name' do
      user1 = User.create(name: "UniqueUser")
      user2 = User.new(name: "UniqueUser")
      expect(user2).not_to be_valid
      expect(user2.errors[:name]).to include("has already been taken")
    end
  end
end
