require 'rails_helper'

RSpec.describe Comment, type: :model do
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
