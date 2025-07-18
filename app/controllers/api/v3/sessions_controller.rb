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

module API
  module V3
    # API session handling. API authentication is done using:
    #   Authorization: Bearer <token>
    #
    # @note this is a guess at what needs to be implemented.
    #
    # @todo Investigate how puppet gets it's login information. Until then, this is only a placeholder.
    class SessionsController < APIController
      allow_unauthenticated_access only: %i[create]
      rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render json: {reason: "Too many requests. Please try again later."}, status: :too_many_requests }

      def create
        if (user = User.authenticate_by(params.permit(:email_address, :password)))
          start_new_session_for user
          render json: {token: Current.session.token}
        else
          render status: :unauthorized, json: {
            message: "401 Unauthorized",
            errors: ["Invalid email_address or password."]
          }
        end
      end

      def destroy
        terminate_session
        render status: :no_content
      end
    end
  end
end
