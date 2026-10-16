require "test_helper"

class TicketWorkflowTest < ActionDispatch::IntegrationTest
  test "a support request can be created, assigned, answered, and solved" do
    post tickets_path, params: { ticket: { requester_name: "Ada Yılmaz", requester_email: "ada@example.com", subject: "Giriş yapamıyorum", description: "Parolamı sıfırlayamıyorum.", priority: "high" } }
    ticket = Ticket.order(:id).last
    assert_redirected_to ticket_path(ticket)

    patch assign_ticket_path(ticket), params: { assignee: "Ece Demir" }
    assert_equal "Ece Demir", ticket.reload.assignee

    post replies_ticket_path(ticket), params: { reply: { body: "Size yardımcı oluyorum." } }
    assert_equal "open", ticket.reload.status
    assert ticket.first_response_at.present?

    patch solve_ticket_path(ticket)
    assert_equal "solved", ticket.reload.status
  end
end
