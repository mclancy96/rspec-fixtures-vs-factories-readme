require 'rails_helper'

RSpec.describe Volunteer, type: :model do
  context 'with FactoryBot' do
    it 'is valid with valid attributes' do
      volunteer = build(:volunteer)
      expect(volunteer).to be_valid
    end

    it 'can be created with an organization' do
      org = create(:organization)
      volunteer = create(:volunteer, organization: org)
      expect(volunteer.organization).to eq(org)
    end

    it 'can have many shifts' do
      volunteer = create(:volunteer)
      shift1 = create(:shift)
      shift2 = create(:shift)
      volunteer.shifts << [shift1, shift2]
      expect(volunteer.shifts.count).to eq(2)
    end

    it 'can use a trait (pending)' do
      skip('Try adding a trait to the volunteer factory')
    end
  end

  context 'with fixtures' do
    fixtures :volunteers, :organizations

    it 'loads a volunteer from fixtures' do
      expect(volunteers(:alice)).to be_a(Volunteer)
      expect(volunteers(:alice).organization).to eq(organizations(:org_one))
    end

    it 'can access associated organization' do
      expect(volunteers(:bob).organization.name).to eq('Habitat for Humanity')
    end

    it 'can be assigned to a shift (pending)' do
      skip('Try assigning a shift to a volunteer using fixtures')
    end
  end
end
