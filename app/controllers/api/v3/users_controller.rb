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
    # User Operations
    class UsersController < APIController
      allow_unauthenticated_access only: %i[index show]

      # Provides information about Puppet Forge user accounts.
      # By default, results are returned in alphabetical order by username and paginated with 20 users per page.
      # It's also possible to sort by number of published releases, total download counts for all the user's modules, or by the date of the user's latest release.
      # All parameters are optional.
      def index
        render json: paginate(User.all)
      end

      # Returns data for a single User resource identified by the user's slug value.
      def show
        if (user = User.find_by(username: params[:slug]))
          render json: user.to_forgeapi(include_fields: show_params[:include_fields] || [], exclude_fields: show_params[:exclude_fields] || [])
        else
          not_found_error
        end
      end

      private

      def index_params
        params.permit(:sort_by, :with_html, :include_fields, :exclude_fields)
      end

      def show_params
        params.permit(:with_html, include_fields: [], exclude_fields: [])
      end
    end
  end
end
