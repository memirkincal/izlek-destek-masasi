require "test_helper"

class TicketTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  setup do
    travel_to Time.zone.local(2026, 10, 16, 12, 0)
    @ticket = Ticket.create!(requester_name: "Ada Yılmaz", requester_email: "ada@example.com", subject: "Fatura", description: "Faturamı göremiyorum")
  end

  teardown do
    travel_back
  end

  test "starts a four hour first response SLA when created" do
    assert_equal 4.hours.from_now, @ticket.response_due_at
    assert_equal :on_track, @ticket.sla_state
  end

  test "marks the SLA at risk in the final thirty minutes and breached at the deadline" do
    travel_to @ticket.response_due_at - 29.minutes
    assert_equal :at_risk, @ticket.sla_state

    travel_to @ticket.response_due_at
    assert_equal :breached, @ticket.sla_state
    assert_equal "Süre aşıldı", @ticket.sla_remaining
  end

  test "allows only the intended status transitions" do
    assert_not @ticket.solve!
    assert @ticket.open!
    assert_equal "open", @ticket.reload.status
    assert @ticket.solve!
    assert_equal "solved", @ticket.reload.status
    assert_equal Time.current, @ticket.solved_at
    assert @ticket.reopen!
    assert_equal "open", @ticket.reload.status
    assert_nil @ticket.solved_at
  end

  test "the first public reply stops the SLA and moves a new ticket to open" do
    travel_to 37.minutes.from_now do
      @ticket.replies.create!(author_name: "Ece Demir", body: "Faturanızı kontrol ediyorum.")
    end

    assert_equal "open", @ticket.reload.status
    assert_equal Time.zone.local(2026, 10, 16, 12, 37), @ticket.first_response_at
    assert_equal :responded, @ticket.sla_state
  end

  test "a reply on a solved ticket does not silently reopen it" do
    @ticket.update!(status: "solved", solved_at: Time.current, first_response_at: Time.current)
    @ticket.replies.create!(author_name: "Ece Demir", body: "Bu kayıt kapalı kalmalı.")

    assert_equal "solved", @ticket.reload.status
  end
end
