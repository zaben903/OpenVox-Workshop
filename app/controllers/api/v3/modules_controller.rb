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
    # Module Operations
    class ModulesController < APIController
      include ForgeV3APIErrors

      allow_unauthenticated_access # only: [:index, :show]

      # Returns a list of modules meeting the specified search criteria and filters.
      # Results are paginated. All of the parameters are optional.
      def index
        render json: paginate(index_params_to_query(OpenVoxModule.active))
      end

      # Returns data for a single Module resource identified by the module's slug value.
      def show
        if (openvox_module = OpenVoxModule.active.find_by(slug: params[:slug]))
          render json: openvox_module.to_forgeapi(include_fields: show_params[:include_fields] || [], exclude_fields: show_params[:exclude_fields] || [])
        else
          not_found_error
        end
      end

      # Perform a soft delete of a module, identified by the module's slug value.
      # The module's releases will still be available for direct download via their associated /v3/files endpoints,
      # but the module will no longer be readily available through the Forge web interface.
      #
      # @todo Implement once session handling is implemented
      def destroy
        not_implemented_error
        # if (openvox_module = OpenVoxModule.joins(:releases).active.find_by(slug: params[:slug]))
        #   return unauthorised_error if cannot?(:destroy, OpenVoxModule)
        #
        #   render status: :no_content if openvox_module.soft_delete!(reason: delete_params[:reason])
        # else
        #   not_found_error
        # end
      end

      # Mark a module, identified by the module's slug value, as "deprecated".
      # Deprecated modules are still visible on the Forge website, but users are directed to strongly consider alternate modules.
      # Because the deprecate action is intended to be one-way, there is no operation for undeprecating a module.
      #
      # @todo Implement once session handling is implemented
      def deprecate
        not_implemented_error
        # if (openvox_module = OpenVoxModule.active.find_by(slug: params[:slug]))
        #   return unauthorised_error if cannot?(:deprecate, openvox_module)
        #
        #   if openvox_module.update!(deprecated_at: Time.zone.now, deprecated_for: deprecate_params.dig(:params, :reason))
        #     render status: :no_content
        #   end
        # else
        #   not_found_error
        # end
      end

      private

      def index_params
        params.permit(:sort_by, :query, :tag, :owner, :with_tasks, :with_plans, :with_pdk,
          :premium, :exclude_premium, :endorsements, :operatingsystem, :operatingsystemrelease,
          :pe_requirement, :puppet_requirement, :with_minimum_score, :module_groups, :show_deleted,
          :hide_deprecated, :hide_contribution, :only_latest, :with_html, :starts_with, :supported,
          :with_release_since, slugs: [], include_fields: [], exclude_fields: [])
      end

      # Converts Forge API params to OpenVoxModule fields
      #
      # @param [OpenVoxModule::ActiveRecord_Relation]
      #
      # @return [OpenVoxModule::ActiveRecord_Relation]
      #
      # @todo `sort_by` needs to be implemented to support options: ["rank", "downloads", "latest_release"]
      def index_params_to_query(openvox_module)
        index_params.each_pair do |param, value|
          openvox_module =
            case param
            when :sort_by
              openvox_module.order(downloads: :desc)
            when :query
              openvox_module.where("name ILIKE ?", "%#{value}%")
            when :owner
              openvox_module.where(user: value)
            when :show_deleted
              openvox_module.where(deleted: [true, false]) if value
            when :hide_deprecated
              openvox_module.where(deprecated_at: nil)
            when :starts_with
              openvox_module.where("stub ILIKE ?", "#{value}%")
            when :with_release_since
              openvox_module.where(releases: {created_at: Date.iso8601(value)..})
            when :slugs
              openvox_module.where(slug: value)
            else
              next
            end
        end

        openvox_module
      end

      def show_params
        params.permit(:with_html, include_fields: [], exclude_fields: [])
      end

      def delete_params
        params.expect(:reason)
      end

      def deprecate_params
        params.expect(:action, params: [:reason, :replacement_slug])
      end
    end
  end
end
