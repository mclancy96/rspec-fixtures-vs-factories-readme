require 'rails_helper'

RSpec.describe Shift, type: :model do
  context 'with FactoryBot' do
    it 'is valid with valid attributes' do
      shift = build(:shift)
      expect(shift).to be_valid
    end

    it 'is invalid if ends_at is before starts_at' do
      shift = build(:shift, starts_at: 2.days.from_now, ends_at: 1.day.from_now)
      expect(shift).not_to be_valid
    end

    it 'can have many volunteers' do
      shift = create(:shift)
      v1 = create(:volunteer)
      v2 = create(:volunteer)
      shift.volunteers << [v1, v2]
      expect(shift.volunteers.count).to eq(2)
    end

    it 'can use a trait (pending)' do
      skip('Try adding a trait to the shift factory')
    end
  end

  context 'with fixtures' do
    fixtures :shifts, :organizations

    it 'loads a shift from fixtures' do
      expect(shifts(:morning)).to be_a(Shift)
      expect(shifts(:morning).organization).to eq(organizations(:org_one))
    end

    it 'can access associated organization' do
      expect(shifts(:afternoon).organization.name).to eq('Habitat for Humanity')
    end

    it 'can be assigned a volunteer (pending)' do
      skip('Try assigning a volunteer to a shift using fixtures')
    end
  end
end
