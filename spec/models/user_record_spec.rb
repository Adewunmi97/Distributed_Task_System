# spec/models/user_record_spec.rb

require 'rails_helper'

RSpec.describe UserRecord, type: :model do
  describe 'associations' do
    it { should have_many(:created_tasks).class_name('TaskRecord').with_foreign_key('creator_id') }
    it { should have_many(:assigned_tasks).class_name('TaskRecord').with_foreign_key('assignee_id') }
  end

  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should allow_value('user@example.com').for(:email) }
    it { should_not allow_value('invalid_email').for(:email) }
    it { should validate_length_of(:password).is_at_least(8).on(:create) }
    it { should validate_presence_of(:role) }
    it do
      create(:user)
      should validate_uniqueness_of(:email).case_insensitive
    end    
  end

  describe 'enums' do
    it {
      should define_enum_for(:role)
        .with_values(
          member: 'member',
          manager: 'manager',
          admin: 'admin'
        )
        .backed_by_column_of_type(:string)
        .with_prefix(:role)
    }
  end

  describe 'callbacks' do
    describe 'before_save :downcase_email' do
      it 'downcases email before saving' do
        user = create(:user, email: 'USER@EXAMPLE.COM')
        expect(user.reload.email).to eq('user@example.com')
      end
    end
  end

  describe '#admin?' do
    it 'returns true for admin users' do
      user = build(:user, :admin)
      expect(user.admin?).to be true
    end

    it 'returns false for non-admin users' do
      user = build(:user, :member)
      expect(user.admin?).to be false
    end
  end

  describe '#manager?' do
    it 'returns true for managers' do
      user = build(:user, :manager)
      expect(user.manager?).to be true
    end

    it 'returns true for admins' do
      user = build(:user, :admin)
      expect(user.manager?).to be true
    end

    it 'returns false for members' do
      user = build(:user, :member)
      expect(user.manager?).to be false
    end
  end

  describe '#can_assign_tasks?' do
    it 'returns true for users who can assign tasks' do
      manager = build(:user, :manager)
      expect(manager.can_assign_tasks?).to be true
    end

    it 'returns false for members' do
      member = build(:user, :member)
      expect(member.can_assign_tasks?).to be false
    end
  end

  describe 'password encryption' do
    it 'encrypts password using bcrypt' do
      user = create(:user, password: 'securepassword', password_confirmation: 'securepassword')
      expect(user.password_digest).not_to eq('securepassword')
      expect(user.authenticate('securepassword')).to eq(user)
    end
  end
end