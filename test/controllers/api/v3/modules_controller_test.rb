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

class API::V3::ModulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @openvox_module = openvox_modules(:active)
    @user = users(:one)
  end

  test "should get index" do
    get api_v3_modules_url
    assert_response :success
  end

  test "should get index with filters" do
    get api_v3_modules_url, params: {
      owner: @user.username
    }
    assert_response :success
  end

  test "should show module" do
    get api_v3_module_url(@openvox_module.slug)
    assert_response :success
  end

  test "should show module with included fields" do
    get api_v3_module_url(@openvox_module.slug), params: {
      include_fields: ["name", "owner"]
    }
    assert_response :success
  end

  test "should return not found for non-existent module" do
    get api_v3_module_url("non-existent-slug")
    assert_response :not_found
  end

  # test "should destroy module when authorized" do
  #   sign_in @user
  #   delete api_v3_module_url(@openvox_module.slug), params: {
  #     reason: "Test deletion reason"
  #   }
  #   assert_response :no_content
  # end

  # test "should not destroy module when unauthorized" do
  #   delete api_v3_module_url(@openvox_module.slug), params: {
  #     reason: "Test deletion reason"
  #   }
  #   assert_response :unauthorized
  # end

  # test "should deprecate module when authorized" do
  #   sign_in @user
  #   put api_v3_module_deprecate_url(@openvox_module.slug), params: {
  #     action: "deprecate",
  #     params: {
  #       reason: "Test deprecation reason",
  #       replacement_slug: "replacement-module"
  #     }
  #   }
  #   assert_response :no_content
  #   assert_not_nil @openvox_module.reload.deprecated_at
  # end

  # test "should not deprecate module when unauthorized" do
  #   patch api_v3_module_deprecate_url(@openvox_module.slug), params: {
  #     action: "deprecate",
  #     params: {
  #       reason: "Test deprecation reason"
  #     }
  #   }
  #   assert_response :unauthorized
  # end

  # test "should return not found when deprecating non-existent module" do
  #   sign_in @user
  #   put deprecate_api_v3_module_url("non-existent-slug"), params: {
  #     action: "deprecate",
  #     params: {
  #       reason: "Test deprecation reason"
  #     }
  #   }
  #   assert_response :not_found
  # end
end
