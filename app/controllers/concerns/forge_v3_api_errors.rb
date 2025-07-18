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

module ForgeV3APIErrors
  extend ActiveSupport::Concern

  private

  # @param [Array<String>] reasons for the bad request
  def bad_request_error(reasons)
    render status: :bad_request, json: {
      message: "400 Bad Request",
      errors: reasons
    }
  end

  def not_found_error
    render status: :not_found, json: {
      message: "404 Not Found",
      errors: ["The requested resource could not be found"]
    }
  end

  def unauthorised_error
    render status: :unauthorized, json: {
      message: "401 Unauthorized",
      errors: ["This endpoint requires a valid Authorization header"]
    }
  end

  def forbidden_error
    render status: :forbidden, json: {
      message: "403 Forbidden",
      errors: ["The provided API key is invalid or has insufficient permissions for the requested operation"]
    }
  end

  def not_implemented_error
    render status: :not_implemented, json: {
      message: "501 Not Implemented",
      errors: ["Search Filters are not implemented on this server."]
    }
  end
end
