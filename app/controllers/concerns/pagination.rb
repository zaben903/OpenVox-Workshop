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

module Pagination
  extend ActiveSupport::Concern

  included do
    helper_method :paginate
  end

  private

  # Returns a paginated array of the requested model
  #
  # @param model [ActiveRecord::Relation<Any>]
  #
  # @return [Hash]
  #
  # @todo Handle `include_fields` and `exclude_fields`
  # @todo Handle non-Forge API pagination
  def paginate(model)
    {
      pagination: {
        limit: limit,
        offset: offset,
        first: "#{request.path}?#{{offset: 0, limit: limit}.to_query}",
        previous: (offset == 0) ? nil : "#{request.path}?#{{offset: offset, limit: limit}.to_query}",
        current: "#{request.path}?#{{offset: offset, limit: limit}.to_query}",
        next: "#{request.path}?#{{offset: offset + limit, limit: limit}.to_query}",
        total: model.count
      },
      results: model.offset(offset).limit(limit).order(sort_by(model)).map(&:to_forgeapi)
    }
  end

  def paginate_params
    params.permit(:limit, :offset)
  end

  def limit
    paginate_params[:limit] || 20
  end

  def offset
    paginate_params[:offset] || 0
  end

  # Forge API Release available values : downloads, release_date, module
  # Forge API OpenVoxModule available values : rank, downloads, latest_release
  #
  # @param model [ApplicationRecord]
  #
  # @return [Symbol]
  #
  # @todo Handle Release "module" sort_by option
  # @todo Handle OpenVoxModule "rank" and "latest_release" options
  def sort_by(model)
    sort_by_param = params.permit(:sort_by)
    if model.is_a? Release
      case sort_by_param[:sort_by]
      when "downloads"
        :downloads
      when "release_date"
        :created_at
      else
        :downloads
      end
    elsif model.is_a? OpenVoxModule
      case sort_by_param[:sort_by]
      when "downloads"
        :downloads
      else
        :downloads
      end
    end
  end
end
