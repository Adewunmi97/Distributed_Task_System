class EventRecord < ApplicationRecord
  self.table_name = 'events'

  # Associations
  belongs_to :task, class_name: 'TaskRecord', optional: true

  # Validations
  validates :event_type, presence: true, format: { with: /\A[a-z_]+\.[a-z_]+\z/ }
  validates :payload, presence: true

  # Scopes
  scope :unprocessed, -> { where(processed_at: nil) }
  scope :processed, -> { where.not(processed_at: nil) }
  scope :by_type, ->(type) { where(event_type: type) }
  scope :recent, -> { order(created_at: :desc) }

  # Instance methods
  def processed?
    processed_at.present?
  end

  def mark_as_processed!
    update!(processed_at: Time.current)
  end

  def task_event?
    event_type.start_with?('task.')
  end

  def user_event?
    event_type.start_with?('user.')
  end
end