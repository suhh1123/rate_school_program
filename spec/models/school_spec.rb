require 'rails_helper'

RSpec.describe School, type: :model do
  describe '#validation' do
    let(:school) { FactoryBot.create :school }

    it 'is valid with valid factory' do
      expect(school).to be_valid
    end

    it 'is invalid without name' do
      school.name = nil
      expect(school).not_to be_valid
      expect(school.errors.messages[:name]).to include("can't be blank")
    end

    it 'is invalid without unique name' do
      second_school = FactoryBot.build :school
      second_school.name = school.name
      expect(second_school).not_to be_valid
      expect(second_school.errors.messages[:name]).to include("has already been taken")
    end

    it 'is not case-sensitive in terms of unique name' do
      second_school = FactoryBot.build :school
      second_school.name = school.name.swapcase
      expect(second_school).not_to be_valid
    end

    it 'is invalid with invalid zipcode format' do
      school.zipcode = "invalid_zipcode"
      expect(school).not_to be_valid
      expect(school.errors.messages[:zipcode]).to include("is invalid")
    end
  end

  describe '#association' do
    it 'should have many programs' do
      t = described_class.reflect_on_association(:programs)
      expect(t.macro).to eq(:has_many)
    end
  end
end
