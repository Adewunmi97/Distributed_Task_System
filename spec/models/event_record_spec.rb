require 'rails_helper'

RSpec.describe EventRecord, type: :model do
  describe 'associations' do
    it { should belong_to(:task).class_name('TaskRecord').optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:event_type) }
    it { should allow_value('task.created').for(:event_type) }
    it { should allow_value('user.registered').for(:event_type) }
    it { should_not allow_value('Invalid').for(:event_type) }
    it { should_not allow_value('task_created').for(:event_type) }
    it { should validate_presence_of(:payload) }
  end

  describe 'scopes' do
    let!(:processed_event) { create(:event, :processed) }
    let!(:unprocessed_event) { create(:event, :unprocessed) }
    let!(:task_event) { create(:event, :task_created) }
    let!(:old_event) { create(:event, created_at: 2.days.ago) }

    describe '.unprocessed' do
      it 'returns unprocessed events' do
        expect(EventRecord.unprocessed).to include(unprocessed_event)
        expect(EventRecord.unprocessed).not_to include(processed_event)
      end
    end

    describe '.processed' do
      it 'returns processed events' do
        expect(EventRecord.processed).to include(processed_event)
        expect(EventRecord.processed).not_to include(unprocessed_event)
      end
    end

    describe '.by_type' do
      it 'returns events of specific type' do
        expect(EventRecord.by_type('task.created')).to include(task_event)
      end
    end

    describe '.recent' do
      it 'returns events ordered by creation time' do
        expect(EventRecord.recent.first).not_to eq(old_event)
      end
    end
  end

  describe '#processed?' do
    it 'returns true when processed_at is set' do
      event = build(:event, :processed)
      expect(event.processed?).to be true
    end

    it 'returns false when processed_at is nil' do
      event = build(:event, :unprocessed)
      expect(event.processed?).to be false
    end
  end

  describe '#mark_as_processed!' do
    it 'sets processed_at timestamp' do
      event = create(:event, :unprocessed)
      expect {
        event.mark_as_processed!
      }.to change { event.processed_at }.from(nil)
    end
  end

  describe '#task_event?' do
    it 'returns true for task events' do
      event = build(:event, event_type: 'task.created')
      expect(event.task_event?).to be true
    end

    it 'returns false for non-task events' do
      event = build(:event, event_type: 'user.registered')
      expect(event.task_event?).to be false
    end
  end

  describe '#user_event?' do
    it 'returns true for user events' do
      event = build(:event, event_type: 'user.registered')
      expect(event.user_event?).to be true
    end

    it 'returns false for non-user events' do
      event = build(:event, event_type: 'task.created')
      expect(event.user_event?).to be false
    end
  end
end