class Ticket < ApplicationRecord
  STATUSES = %w[new open solved].freeze
  PRIORITIES = %w[low normal high urgent].freeze
  AGENTS = ["Ece Demir", "Mert Kaya", "Deniz Arslan"].freeze
  FIRST_RESPONSE_SLA = 4.hours

  has_many :replies, dependent: :destroy

  validates :requester_name, :requester_email, :subject, :description, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :priority, inclusion: { in: PRIORITIES }
  validates :assignee, inclusion: { in: AGENTS }, allow_blank: true
  validates :subject, length: { maximum: 120 }

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
    return "Süre aşıldı" if seconds <= 0

    hours, remainder = seconds.divmod(3600)
    minutes = remainder / 60
    hours.positive? ? "#{hours} sa #{minutes} dk" : "#{minutes} dk"
  end

  def next_action
    return "İlk yanıtı gönder" if first_response_due?
    return "Talebi aç" if status == "new"
    return "Çözümü doğrula" if status == "open"

    "Tamamlandı"
  end

  private

  def set_defaults
    self.status ||= "new"
    self.priority ||= "normal"
  end

  def set_response_deadline
    self.response_due_at ||= (created_at || Time.current) + FIRST_RESPONSE_SLA
  end
end
