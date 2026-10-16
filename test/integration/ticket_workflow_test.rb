require "test_helper"

class TicketWorkflowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as(users(:one))
  end

  test "a support request can be created, assigned, answered, and solved" do
    post tickets_path, params: { ticket: { subject: "Giriş yapamıyorum", description: "Parolamı sıfırlayamıyorum.", priority: "high" } }
    ticket = Ticket.order(:id).last
    assert_redirected_to ticket_path(ticket)
    assert_equal users(:one).organization, ticket.organization
    assert_equal users(:one), ticket.requester_user

    patch assign_ticket_path(ticket), params: { assignee_user_id: users(:one).id }
    assert_equal users(:one), ticket.reload.assignee_user

    post replies_ticket_path(ticket), params: { reply: { body: "Size yardımcı oluyorum." } }
    assert_equal "open", ticket.reload.status
    assert ticket.first_response_at.present?
    assert_equal users(:one), ticket.replies.last.user

    patch solve_ticket_path(ticket)
    assert_equal "solved", ticket.reload.status
  end

  test "a new account creates a private workspace and becomes its administrator" do
    assert_difference [ "Organization.count", "User.count" ], 1 do
      post registrations_path, params: {
        organization: { name: "Acme Helpdesk" },
        user: { name: "Ada Founder", email_address: "ada@acme.test", password: "StrongPass123!", password_confirmation: "StrongPass123!" }
      }
    end

    assert_redirected_to root_path
    created_user = User.find_by!(email_address: "ada@acme.test")
    assert_equal "admin", created_user.role
    assert_equal "Acme Helpdesk", created_user.organization.name
  end

  test "a requester sees only their own workspace tickets" do
    requester = users(:two)
    own_ticket = requester.organization.tickets.create!(requester_user: requester, requester_name: requester.name,
                                                         requester_email: requester.email_address, subject: "Kendi talebim",
                                                         description: "Yardım gerekiyor")
    other_requester = requester.organization.users.create!(name: "Another", email_address: "another@fixture.test",
                                                            role: "requester", password: "password123")
    other_requester.organization.tickets.create!(requester_user: other_requester, requester_name: other_requester.name,
                                                  requester_email: other_requester.email_address, subject: "Başka talep",
                                                  description: "Gizli kayıt")
    sign_out
    sign_in_as(requester)

    get tickets_path

    assert_response :success
    assert_includes response.body, own_ticket.subject
    assert_not_includes response.body, "Gizli kayıt"
  end

  test "a user cannot open a ticket from another workspace" do
    other_organization = Organization.create!(name: "Private workspace")
    other_requester = other_organization.users.create!(name: "Private Person", email_address: "private@workspace.test",
                                                        role: "requester", password: "password123")
    private_ticket = other_organization.tickets.create!(requester_user: other_requester, requester_name: other_requester.name,
                                                         requester_email: other_requester.email_address, subject: "Private ticket",
                                                         description: "Must stay private")

    get ticket_path(private_ticket)

    assert_response :not_found
  end

  test "requester cannot assign or solve a ticket" do
    requester = users(:two)
    ticket = requester.organization.tickets.create!(requester_user: requester, requester_name: requester.name,
                                                     requester_email: requester.email_address, subject: "Cannot change status",
                                                     description: "Only staff can change state")
    sign_out
    sign_in_as(requester)

    patch solve_ticket_path(ticket)

    assert_redirected_to root_path
    assert_equal "new", ticket.reload.status
  end
end
