require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '#validation' do
    let(:comment) do
      school = FactoryBot.create :school
      program = FactoryBot.create :program, school: school
      user = FactoryBot.build :user
      user.password = 'sample_password'
      user.save
      comment = FactoryBot.create :comment, user: user, program: program
    end

    it 'is valid with valid factory' do
      expect(comment).to be_valid
    end

    it 'is invalid without title' do
      comment.title = nil
      expect(comment).not_to be_valid
    end

    it 'is invalid without content' do
      comment.content = nil
      expect(comment).not_to be_valid
    end
  end

  describe '#association' do
    it 'should belong to one user' do
      t = described_class.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end

    it 'should belong to one comment' do
      t = described_class.reflect_on_association(:program)
      expect(t.macro).to eq(:belongs_to)
    end
  end
end
