class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  belongs_to :organization, optional: true
  has_many :requested_tickets, class_name: "Ticket", foreign_key: :requester_user_id, dependent: :restrict_with_error
  has_many :assigned_tickets, class_name: "Ticket", foreign_key: :assignee_user_id, dependent: :nullify
  has_many :replies, dependent: :nullify

  ROLES = %w[admin agent requester].freeze

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true, length: { maximum: 80 }
  validates :email_address, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :role, inclusion: { in: ROLES }
  validates :organization, presence: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  def admin?
    role == "admin"
  end

  def agent?
    role == "agent"
  end

  def requester?
    role == "requester"
  end

  def support_staff?
    admin? || agent?
  end
end
