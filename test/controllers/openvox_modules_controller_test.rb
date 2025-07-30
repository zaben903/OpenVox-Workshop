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

class OpenVoxModulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @openvox_module = openvox_modules(:active)
    @user = users(:one)
  end

  test "should get index" do
    get modules_url
    assert_response :success
  end

  test "should get show" do
    get module_url(@openvox_module.slug)
    assert_response :success
  end

  test "should return not found for non-existent module" do
    get module_url("nonexistentslug")
    assert_response :not_found
  end
end
