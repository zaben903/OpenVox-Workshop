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

class OpenVoxModulesController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]

  def index
    @modules = OpenVoxModule.includes(:user).active.order(:downloads).limit(10)
  end

  def show
    @module = OpenVoxModule.includes(:user).find_by!(slug: params[:slug])
  end
end
