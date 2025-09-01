require 'rails_helper'

RSpec.describe Organization, type: :model do
  context 'with FactoryBot' do
    it 'is valid with valid attributes' do
      org = build(:organization)
      expect(org).to be_valid
    end

    it 'can have many volunteers' do
      org = create(:organization)
      v1 = create(:volunteer, organization: org)
      v2 = create(:volunteer, organization: org)
      expect(org.volunteers.count).to eq(2)
    end

    it 'can have many shifts' do
      org = create(:organization)
      s1 = create(:shift, organization: org)
      s2 = create(:shift, organization: org)
      expect(org.shifts.count).to eq(2)
    end

    it 'can use a trait (pending)' do
      skip('Try adding a trait to the organization factory')
    end
  end

  context 'with fixtures' do
    fixtures :organizations, :volunteers, :shifts

    it 'loads an organization from fixtures' do
      expect(organizations(:org_one)).to be_a(Organization)
    end

    it 'can access associated volunteers' do
      expect(organizations(:org_one).volunteers.map(&:name)).to include('Alice')
    end

    it 'can access associated shifts' do
      expect(organizations(:org_one).shifts.map(&:starts_at)).to include(Time.zone.parse('2025-09-01 08:00:00'))
    end
  end
end
