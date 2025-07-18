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

# == Schema Information
#
# Table name: releases
#
#  id                :bigint           not null, primary key
#  changelog         :string
#  deleted_at        :datetime
#  deleted_for       :string
#  downloads         :integer
#  file_md5          :string           not null
#  file_sha256       :string           not null
#  file_size         :integer          not null
#  license           :string
#  metadata          :json             not null
#  readme            :string
#  reference         :string
#  slug              :string           not null
#  version           :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  openvox_module_id :bigint           not null
#
# Indexes
#
#  index_releases_on_openvox_module_id              (openvox_module_id)
#  index_releases_on_openvox_module_id_and_version  (openvox_module_id,version) UNIQUE
#  index_releases_on_slug                           (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (openvox_module_id => openvox_modules.id)
#
require "test_helper"

class ReleaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
