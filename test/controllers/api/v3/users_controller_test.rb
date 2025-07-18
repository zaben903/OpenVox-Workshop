# frozen_string_literal: true

# Copyright (C) 2025 Zachary Bensley
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
