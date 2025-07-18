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

class API::V3::ReleasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @release = releases(:active_release)
  end

  test "should get index" do
    get api_v3_releases_url
    assert_response :success
    assert_kind_of Array, JSON.parse(@response.body)["results"]
  end

  test "should get index with parameters" do
    get api_v3_releases_url, params: {
      sort_by: "name",
      module: "test",
      owner: "test_owner",
      with_pdk: true,
      include_fields: %w[name version],
      exclude_fields: ["description"]
    }
    assert_response :success
  end

  test "should show release" do
    get api_v3_release_show_url(@release.slug)
    assert_response :success
    assert_equal @release.slug, JSON.parse(@response.body)["slug"]
  end

  test "should return not found for non-existent release" do
    get api_v3_release_show_url("non-existent-0.0.1")
    assert_response :not_found
  end

  test "should return not found for invalid slug" do
    get api_v3_release_show_url("non-existent-slug")
    assert_response :bad_request
  end

  test "should show release with include_fields" do
    get api_v3_release_show_url(@release.slug), params: {
      include_fields: %w[slug version]
    }
    assert_response :success
    response_body = JSON.parse(@response.body)
    assert_includes response_body.keys, "slug"
    assert_includes response_body.keys, "version"
  end

  test "should show release with exclude_fields" do
    get api_v3_release_show_url(@release.slug), params: {
      exclude_fields: ["license"]
    }
    assert_response :success
    response_body = JSON.parse(@response.body)
    assert_not_includes response_body.keys, "license"
  end
end
