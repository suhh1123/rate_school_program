require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validation' do
    it 'is valid with valid factory' do
      user = FactoryBot.build :user
      expect(user).to be_valid
    end

    it 'is not valid without username' do
      user = FactoryBot.build :user, username: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:username]).to include("can't be blank")
    end

    it 'is not valid without password_hash' do
      user = FactoryBot.build :user, password_hash: nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:password_hash]).to include("can't be blank")
    end

    it 'is not valid without unique username' do
      user = FactoryBot.create :user
      second_user = FactoryBot.build :user, username: user.username
      expect(second_user).not_to be_valid
      expect(second_user.errors.messages[:username]).to include("has already been taken")
    end

    it 'is not valid without unique email' do
      user = FactoryBot.create :user
      second_user = FactoryBot.build :user, email: user.email
      expect(second_user).not_to be_valid
      expect(second_user.errors.messages[:email]).to include("has already been taken")
    end
  end
end
