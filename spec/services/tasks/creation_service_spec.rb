# spec/services/tasks/creation_service_spec.rb

require 'rails_helper'

RSpec.describe Tasks::CreationService do
  describe '#call' do
    let(:user) { create(:user) }
    let(:task_repository) { instance_double(TaskRepository) }
    let(:event_publisher) { instance_double(EventPublisher) }
    
    let(:service) do
      described_class.new(
        task_repository: task_repository,
        event_publisher: event_publisher,
        current_user: user
      )
    end

    let(:task_params) do
      {
        title: 'Test Task',
        description: 'Test Description'
      }
    end

    context 'with valid parameters' do
      let(:saved_task) { Task.new(id: 1, title: 'Test Task', creator_id: user.id) }

      before do
        allow(task_repository).to receive(:save).and_return(saved_task)
        allow(event_publisher).to receive(:publish)
      end

      it 'creates a task' do
        result = service.call(task_params)
        
        expect(result.success?).to be true
        expect(result.task).to eq(saved_task)
      end

      it 'publishes task.created event' do
        service.call(task_params)
        
        expect(event_publisher).to have_received(:publish).with(
          event_type: 'task.created',
          payload: { task_id: saved_task.id }
        )
      end
    end

    context 'with invalid parameters' do
      let(:task_params) { { title: '' } }

      it 'returns failure result' do
        result = service.call(task_params)
        
        expect(result.success?).to be false
        expect(result.error).to be_present
      end

      it 'does not publish event' do
        service.call(task_params)
        
        expect(event_publisher).not_to have_received(:publish)
      end
    end
  end
end