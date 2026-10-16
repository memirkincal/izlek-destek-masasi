class Ticket < ApplicationRecord
  STATUSES = %w[new open solved].freeze
  PRIORITIES = %w[low normal high urgent].freeze
  FIRST_RESPONSE_SLA = 4.hours

  belongs_to :organization
  belongs_to :requester_user, class_name: "User"
  belongs_to :assignee_user, class_name: "User", optional: true
  has_many :replies, dependent: :destroy

  validates :requester_name, :requester_email, :subject, :description, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: PRIORITIES }
  validates :subject, length: { maximum: 120 }
  validate :assignee_belongs_to_organization

  before_validation :set_defaults, on: :create
  before_create :set_response_deadline

  scope :active, -> { where.not(status: "solved") }
  scope :ordered_for_attention, -> { order(Arel.sql("CASE priority WHEN 'urgent' THEN 0 WHEN 'high' THEN 1 WHEN 'normal' THEN 2 ELSE 3 END"), :response_due_at) }

  def open!
    return false unless status == "new"

    update(status: "open")
  end

  def solve!
    return false unless status == "open"

    update(status: "solved", solved_at: Time.current)
  end

  def reopen!
    return false unless status == "solved"

    update(status: "open", solved_at: nil)
  end

  def first_response_due?
    first_response_at.nil? && response_due_at.present?
  end

  def sla_state
    return :responded unless first_response_due?
    return :breached if response_due_at <= Time.current
    return :at_risk if response_due_at <= 30.minutes.from_now

    :on_track
  end

  def sla_remaining
    return if response_due_at.blank? || !first_response_due?

    seconds = (response_due_at - Time.current).to_i
    return I18n.t("sla.overdue_time") if seconds <= 0

    hours, remainder = seconds.divmod(3600)
    minutes = remainder / 60
    return I18n.t("sla.remaining_hours", hours: hours, minutes: minutes) if hours.positive?

    I18n.t("sla.remaining_minutes", count: minutes)
  end

  def next_action
    return I18n.t("tickets.next_first_response") if first_response_due?
    return I18n.t("tickets.next_open") if status == "new"
    return I18n.t("tickets.next_solve") if status == "open"

    I18n.t("tickets.next_done")
  end

  def assignee_name
    assignee_user&.name || assignee.presence || "Atanmadı"
  end

  def requester_display_name
    requester_user&.name || requester_name
  end

  def requester_display_email
    requester_user&.email_address || requester_email
  end

  private

  def set_defaults
    self.status ||= "new"
    self.priority ||= "normal"
  end

  def set_response_deadline
    self.response_due_at ||= (created_at || Time.current) + FIRST_RESPONSE_SLA
  end

  def assignee_belongs_to_organization
    return unless assignee_user

    unless assignee_user.organization_id == organization_id && assignee_user.support_staff?
      errors.add(:assignee_user, :invalid)
    end
  end
end
