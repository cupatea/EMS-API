require 'test_helper'

class InviteStoriesTest < ActionDispatch::IntegrationTest
  setup do
    @user_first = User.create!  email: "first@user.com",
                                password: "password"
    @user_second = User.create! email: "second@user.com",
                                password: "password"
    @user_third = User.create! email: "third@user.com",
                                password: "password"

    @event = @user_first.events.create! name: "User first event",
                                        time: Time.now+7.days,
                                        place: "Some place",
                                        purpose: "Some purpose",
                                        owner_id: @user_first.id
  end
  test "User shold be able to invite another user to own event" do
    assert_difference '@user_second.events.count' do
      post invites_path, params: {  auth_token: @user_first.auth_token,
                                    invite:{ invitee_id: @user_second.id, event_id: @event.id} }
      assert_response :success
    end
  end
  test "User shold not be able to invite another second time" do
    @user_second.events << @event
    post invites_path, params: {  auth_token: @user_first.auth_token,
                                  invite:{ invitee_id: @user_second.id, event_id: @event.id} }
    assert_response 403
  end

  test "User should not be able to invite another user to a foreign event" do
    post invites_path, params: { auth_token: @user_third.auth_token,
                                              invite:{ invitee_id: @user_second.id, event_id: @event.id} }
    assert_response 403
  end

end
