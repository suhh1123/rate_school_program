require 'rails_helper'

RSpec.describe Program, type: :model do
  describe '#validation' do
    let(:school) { FactoryBot.create :school }

    let(:program) do
      program = FactoryBot.build :program
      program.school = school
      program.save
      program
    end

    it 'is valid with valid factory' do
      expect(program).to be_valid
    end

    it 'is invalid without title' do
      program.title = nil
      expect(program).not_to be_valid
      expect(program.errors.messages[:title]).to include("can't be blank")
    end

    it 'is valid without unique school and title' do
      second_program = FactoryBot.build :program
      second_program.title = program.title
      second_program.school = school
      expect(second_program).not_to be_valid
      expect(second_program.errors.messages[:title]).to include("has already been taken")

      second_school = FactoryBot.build :school
      second_program.school = second_school
      expect(second_program).to be_valid
    end

    it 'is not case-sensitive in terms of title' do
      second_program = FactoryBot.build :program
      second_program.title = program.title.swapcase
      second_program.school = school
      expect(second_program).not_to be_valid
    end
  end

  describe '#association' do
    it 'should belong to one school' do
      t = described_class.reflect_on_association(:school)
      expect(t.macro).to eq(:belongs_to)
    end

    it 'should have many comments' do
      t = described_class.reflect_on_association(:comments)
      expect(t.macro).to eq(:has_many)
    end
  end
end
