require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe '#association' do
    it 'should belong to one user' do
      t = described_class.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end

    it 'should belong to one program' do
      t = described_class.reflect_on_association(:comment)
      expect(t.macro).to eq(:belongs_to)
    end
  end
end
