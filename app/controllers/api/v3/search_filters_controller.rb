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
    # Search Filters
    #
    # This application does not support Search Filter Operations.
    class SearchFiltersController < APIController
      include ForgeV3APIErrors

      allow_unauthenticated_access

      # Retrieve all search filters for the authenticated user.
      def index
        not_implemented_error
      end

      # Create a new search filter for the authenticated user.
      def create
        not_implemented_error
      end

      # Delete user's search filter by ID for authenticated user.
      def destroy
        not_implemented_error
      end
    end
  end
end
