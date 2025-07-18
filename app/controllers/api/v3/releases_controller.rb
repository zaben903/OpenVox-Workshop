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
    # Release Operations
    class ReleasesController < APIController
      include ForgeV3APIErrors

      allow_unauthenticated_access only: [:index, :show, :plans, :plan]

      # Returns a list of module releases meeting the specified search criteria and filters.
      # Results are paginated. All of the parameters are optional.
      def index
        render json: paginate(index_params_to_query(Release.active))
      end

      # Publish a new module or new release of an existing module
      #
      # @todo Implement once session handling is implemented
      def create
        not_implemented_error
      end

      # Returns data for a single module Release resource identified by the module release's `slug` value.
      def show
        slug = params[:slug].match(SLUG_REGEX)
        return bad_request_error(["'#{params[:slug]}' is not a valid release slug"]) unless slug

        release = Release
          .joins(openvox_module: :user)
          .active
          .find_by(
            user: {username: slug[:user]},
            openvox_module: {slug: slug[:module]},
            version: slug[:version]
          )

        if release
          render json: release.to_forgeapi(include_fields: show_params[:include_fields].to_a, exclude_fields: show_params[:exclude_fields].to_a)
        else
          not_found_error
        end
      end

      # Perform a soft delete of a module release, identified by the module release's slug value.
      # The release will still be available for direct download from it's "/v3/files" endpoint, but will not be readily available in the Forge web interface.
      #
      # @todo Implement once session handling is implemented
      def destroy
        not_implemented_error
        # if (release = Release.active.find_by(slug: params[:slug]))
        #   return unauthorised_error if cannot?(:destroy, release)
        #
        #   render status: :no_content if release.soft_delete!(reason: delete_params[:reason])
        # else
        #   not_found_error
        # end
      end

      # Returns a paginated list of all plans from the module release identified by the release_slug name.
      # The release_slug is composed of the hyphenated module author, name, and version number (example: puppetlabs-lvm-1.4.0).
      #
      # @todo Not currently implemented. Awaiting implementation in Release model
      def plans
        not_implemented_error
      end

      # Returns a summary of the given plan from the module release identified by the release_slug name.
      # The release_slug is composed of the hyphenated module author, name, and version number (example: puppetlabs-lvm-1.4.0).
      # The plan_name should be the full name including the module name (example: lvm::expand).
      #
      # @todo Not currently implemented. Awaiting implementation in Release model
      def plan
        not_implemented_error
      end

      private

      SLUG_REGEX = /\A(?<user>[a-zA-Z0-9]+)[-\/](?<module>[a-z][a-z0-9_]*)[-\/](?<version>[0-9]+\.[0-9]+\.[0-9]+(?<suffix>[\-+].+)?)\z/

      def index_params
        params.permit(:sort_by, :module, :owner, :with_pdk, :operatingsystem, :pe_requirement, :puppet_requirement,
          :module_groups, :show_deleted, :hide_deprecated, :hide_contribution, :with_html, :supported,
          include_fields: [], exclude_fields: [])
      end

      # Converts Forge API params to Release fields
      #
      # @param [Release::ActiveRecord_Relation]
      #
      # @return [Release::ActiveRecord_Relation]
      #
      # @todo `sort_by` needs to be implemented to support options: ["downloads", "release_date", "module"]
      def index_params_to_query(release)
        index_params.each_pair do |param, value|
          release =
            case param
            when :sort_by
              release.order(downloads: :desc)
            when :module
              release.where(openvox_module: {slug: value})
            when :owner
              release.where(user: value)
            when :show_deleted
              release.where(deleted_at: nil).or(where.not(deleted_at: nil)) if value
            else
              next
            end
        end

        release
      end

      def show_params
        params.permit(:with_html, include_fields: [], exclude_fields: [])
      end
    end
  end
end
