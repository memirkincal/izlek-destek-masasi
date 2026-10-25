require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = User.take }

  test "new" do
    get new_session_path
    assert_response :success
    assert_select ".portal-choice-card", 2
  end

  test "selected portal accepts only its own account type" do
    requester = users(:two)

    post session_path, params: { portal: "staff", email_address: requester.email_address, password: "password" }
    assert_redirected_to new_session_path(portal: "staff")
    assert_nil cookies[:session_id]

    post session_path, params: { portal: "requester", email_address: requester.email_address, password: "password" }
    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with valid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with invalid credentials" do
    post session_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    sign_in_as(User.take)

    delete session_path

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end
end
