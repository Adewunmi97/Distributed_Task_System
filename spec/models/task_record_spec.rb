# spec/models/task_record_spec.rb

require 'rails_helper'

RSpec.describe TaskRecord, type: :model do
  describe 'associations' do
    it { should belong_to(:creator).class_name('UserRecord') }
    it { should belong_to(:assignee).class_name('UserRecord').optional }
    it { should have_many(:events).class_name('EventRecord').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(200) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:creator) }
  end

  describe 'enums' do
    it {
      should define_enum_for(:state)
        .with_values(
          draft: 'draft',
          assigned: 'assigned',
          in_progress: 'in_progress',
          completed: 'completed',
          cancelled: 'cancelled'
        )
        .backed_by_column_of_type(:string)
        .with_prefix(:state)
    }
  end

  describe 'scopes' do
    let!(:user) { create(:user) }
    let!(:draft_task) { create(:task, state: 'draft', creator: user) }
    let!(:completed_task) { create(:task, :completed, creator: user) }

    describe '.by_state' do
      it 'returns tasks with specific state' do
        expect(TaskRecord.by_state('draft')).to include(draft_task)
        expect(TaskRecord.by_state('draft')).not_to include(completed_task)
      end
    end

    describe '.assigned_to' do
      let!(:assignee) { create(:user) }
      let!(:assigned_task) { create(:task, :assigned, assignee: assignee) }

      it 'returns tasks assigned to user' do
        expect(TaskRecord.assigned_to(assignee)).to include(assigned_task)
        expect(TaskRecord.assigned_to(assignee)).not_to include(draft_task)
      end
    end

    describe '.created_by' do
      it 'returns tasks created by user' do
        expect(TaskRecord.created_by(user)).to include(draft_task, completed_task)
      end
    end
    
    describe '.pending' do
      it 'returns tasks in pending states' do
        expect(TaskRecord.pending).to include(draft_task)
        expect(TaskRecord.pending).not_to include(completed_task)
      end
    end
    
    describe '.completed_or_cancelled' do
      it 'returns finished tasks' do
        expect(TaskRecord.completed_or_cancelled).to include(completed_task)
        expect(TaskRecord.completed_or_cancelled).not_to include(draft_task)
      end
    end
  end
end