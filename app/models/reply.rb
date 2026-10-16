class Reply < ApplicationRecord
  belongs_to :ticket

  validates :author_name, :body, presence: true
  validates :body, length: { maximum: 2_000 }

  after_create :mark_first_response

  private

  def mark_first_response
    return if internal? || ticket.first_response_at.present?

    new_status = ticket.status == "new" ? "open" : ticket.status
    ticket.update!(first_response_at: created_at, status: new_status)
  end
end
