require "test_helper"

class API::V3::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get api_v3_users_url
    assert_response :success
    assert_kind_of Array, JSON.parse(@response.body)["results"]
  end

  test "should show release" do
    get api_v3_user_url(@user.username)
    assert_response :success
    assert_equal @user.username, JSON.parse(@response.body)["slug"]
  end

  test "should return not found for non-existent user" do
    get api_v3_user_url("does-not-exist")
    assert_response :not_found
  end
end
