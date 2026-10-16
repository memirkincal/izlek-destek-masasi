require "test_helper"

class TicketTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  setup do
    travel_to Time.zone.local(2026, 10, 16, 12, 0)
    @organization = organizations(:demo)
    @requester = users(:two)
    @ticket = @organization.tickets.create!(requester_user: @requester, requester_name: @requester.name,
                                             requester_email: @requester.email_address, subject: "Fatura",
                                             description: "Faturamı göremiyorum")
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
    assert_equal I18n.t("sla.overdue_time"), @ticket.sla_remaining
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
      @ticket.replies.create!(user: users(:one), author_name: users(:one).name, body: "Faturanızı kontrol ediyorum.")
    end

    assert_equal "open", @ticket.reload.status
    assert_equal Time.zone.local(2026, 10, 16, 12, 37), @ticket.first_response_at
    assert_equal :responded, @ticket.sla_state
  end

  test "a reply on a solved ticket does not silently reopen it" do
    @ticket.update!(status: "solved", solved_at: Time.current, first_response_at: Time.current)
    @ticket.replies.create!(user: users(:one), author_name: users(:one).name, body: "Bu kayıt kapalı kalmalı.")

    assert_equal "solved", @ticket.reload.status
  end

  test "an assignee must be support staff from the same organization" do
    other_organization = Organization.create!(name: "Other workspace")
    other_agent = other_organization.users.create!(name: "Other Agent", email_address: "other@workspace.test",
                                                     role: "agent", password: "password123")
    @ticket.assignee_user = other_agent

    assert_not @ticket.valid?
    assert_includes @ticket.errors.attribute_names, :assignee_user
  end
end
