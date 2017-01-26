require 'test_helper'

class RegistrationStoriesTest < ActionDispatch::IntegrationTest
  test "sign up success" do
    post user_registration_path, params: { user:{ email: "registration@test.com", password: "password" }}
    assert_response :success

    assert JSON.parse(response.body)["auth_token"].present?
    assert_equal User.find(JSON.parse(response.body)["id"]).auth_token, JSON.parse(response.body)["auth_token"]
  end

  test "sign up failure" do
    post user_registration_path, params: { user:{ email: "test@test.ua", password: "" }}
    assert_response :unprocessable_entity
  end

end
