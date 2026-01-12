# spec/factories/events.rb

FactoryBot.define do
  factory :event, class: 'EventRecord' do
    event_type { 'task.created' }
    payload { { task_id: 1, user_id: 1 } }
    association :task

    trait :task_created do
      event_type { 'task.created' }
    end

    trait :task_assigned do
      event_type { 'task.assigned' }
      payload { { task_id: 1, assignee_id: 1 } }
    end

    trait :task_completed do
      event_type { 'task.completed' }
      payload { { task_id: 1, completed_by: 1 } }
    end

    trait :processed do
      processed_at { Time.current }
    end

    trait :unprocessed do
      processed_at { nil }
    end
  end
end