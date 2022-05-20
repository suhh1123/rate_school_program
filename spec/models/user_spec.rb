require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validation' do
    let(:user) do
      user = FactoryBot.build :user
      user.password = 'sample_password'
      user.save
      user
    end

    it 'is valid with valid factory' do
      expect(user).to be_valid
    end

    it 'is not valid without username' do
      user.username = nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:username]).to include("can't be blank")
    end

    it 'is not valid without password_hash' do
      user.password_hash = nil
      expect(user).not_to be_valid
      expect(user.errors.messages[:password_hash]).to include("can't be blank")
    end

    it 'is not valid without unique username' do
      second_user = FactoryBot.build :user, username: user.username
      expect(second_user).not_to be_valid
      expect(second_user.errors.messages[:username]).to include("has already been taken")
    end

    it 'is not valid without unique email' do
      second_user = FactoryBot.build :user, email: user.email
      expect(second_user).not_to be_valid
      expect(second_user.errors.messages[:email]).to include("has already been taken")
    end
  end

  describe '.password' do
    it 'hashes the new password' do
      new_password = 'sample_password'
      user = FactoryBot.build :user
      user.password = new_password
      expect(user.password_hash).not_to eq(new_password)
      expect(user.password).to eq(new_password)
    end
  end
end
