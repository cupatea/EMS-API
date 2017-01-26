require 'test_helper'

class CommentStoriesTest < ActionDispatch::IntegrationTest

  setup do
    @user_first = User.create!  email: "first@user.com",
                                password: "password"
    @user_second = User.create! email: "second@user.com",
                                password: "password"
    @user_third = User.create!  email: "third@user.com",
                                password: "password"

    @event = @user_first.events.create! name: "User first event",
                                        time: Time.now+7.days,
                                        place: "Some place",
                                        purpose: "Some purpose",
                                        owner_id: @user_first.id

    @user_second.events << @event
    @comment_firts_user = @user_first.comments.create! content: "User first left a comment",
                                                       event_id: @event.id
    @comment_second_user = @user_second.comments.create! content: "User second left a comment",
                                                      event_id: @event.id

  end

  test "first user shold get comments for the event" do
    get event_comments_path @event, params: { auth_token: @user_first.auth_token }
    assert_response :success

    assert_equal @event.comments.map(&:id), JSON.parse(response.body).map{|x| x["id"]}
  end
  test "second user shold get comments for the event" do
    get event_comments_path @event, params: { auth_token: @user_second.auth_token }
    assert_response :success

    assert_equal @event.comments.map(&:id), JSON.parse(response.body).map{|x| x["id"]}
  end

  test "third user shold not get comments for the event" do
    get event_comments_path @event, params: { auth_token: @user_third.auth_token }
    assert_response 403

  end


  test "first user should be able to create comment for the event" do
    assert_difference '@event.comments.count' do
      post event_comments_path @event, params: { auth_token: @user_first.auth_token,
                                                 comment:{ content: "User_first left one more comment" }}
      assert_response :success
    end
  end

  test "second user should be able to create comment for the event" do
    assert_difference '@event.comments.count' do
      post event_comments_path @event, params: { auth_token: @user_second.auth_token,
                                                 comment:{ content: "User_second left one more comment" }}
      assert_response :success
    end
  end

  test "third user should not be able to create comment for the event" do
    post event_comments_path @event,@comment_firts_user, params: { auth_token: @user_third.auth_token,
                                               comment:{ content: "Nice try, user_third" }}
    assert_response 403
  end

  test "user should be able to update commen own comment" do
    new_content = "I can do this!"
    put "/events/#{@event.id}/comments/#{@comment_firts_user.id}", params: { auth_token: @user_first.auth_token,
                                             comment:{ id: @comment_firts_user.id, content: new_content }}
    assert_response :success
    assert_equal new_content, JSON.parse(response.body)["content"]
  end

  test "user should not be able to update other's comment" do
    new_content = "At least I've tried :("
    put "/events/#{@event.id}/comments/#{@comment_firts_user.id}", params: { auth_token: @user_second.auth_token,
                                             comment:{ id: @comment_firts_user.id, content: new_content }}
    assert_response 403
  end

  test "user should be able to destroy own comment" do
    assert_difference '@event.comments.count', -1 do
      delete "/events/#{@event.id}/comments/#{@comment_firts_user.id}", params: { auth_token: @user_first.auth_token }
      assert_response :success
    end
  end

  test "user should not be able to destroy own comment" do
    delete "/events/#{@event.id}/comments/#{@comment_second_user.id}", params: { auth_token: @user_first.auth_token }
    assert_response 403
  end
end
