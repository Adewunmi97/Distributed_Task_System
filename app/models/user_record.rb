class UserRecord < ApplicationRecord
  self.table_name = 'users'

  has_secure_password

  # Enums
  enum :role, {
    member: "member",
    manager: "manager",
    admin: "admin"
  }, prefix: true

  # Associations
  has_many :created_tasks, class_name: 'TaskRecord', foreign_key: 'creator_id', dependent: :restrict_with_error
  has_many :assigned_tasks, class_name: 'TaskRecord', foreign_key: 'assignee_id', dependent: :nullify

  # Validations
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
  validates :role, presence: true, inclusion: { in: roles.keys }

  # Callbacks
  before_save :downcase_email

  # Instance methods
  def admin?
    role == 'admin'
  end

  def manager?
    role == 'manager' || admin?
  end

  def can_assign_tasks?
    manager?
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end