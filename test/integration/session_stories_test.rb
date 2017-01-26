require 'test_helper'

class SessionStoriesTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create! email: "ems@email.com", password: "password"
    @auth_token = @user.auth_token
  end

  test "sign in success" do
    post user_session_path, params: { session:{ email: @user.email, password: "password" }}
    assert_response :success

    assert JSON.parse(response.body)["auth_token"].present?
    assert_equal User.find(JSON.parse(response.body)["id"]).auth_token, JSON.parse(response.body)["auth_token"]
  end

  test "sign in failure - wrong email" do
    post user_session_path, params: { session:{ email: "wrong@email.com", password: "password" }}
    assert_response :unprocessable_entity
  end

  test "sign in failure - wrong password" do
    post user_session_path, params: { session:{ email: @user.email, password: "wrong_password" }}
    assert_response :unprocessable_entity
  end

  test "logout success" do
    delete destroy_user_session_path, params: { auth_token: @auth_token}
    assert_response :success
  end
end
