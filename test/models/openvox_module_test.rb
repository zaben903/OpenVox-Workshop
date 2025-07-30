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
# Table name: openvox_modules
#
#  id               :bigint           not null, primary key
#  deleted          :boolean          default(FALSE)
#  deprecated_at    :datetime
#  deprecated_for   :string
#  description      :string           not null
#  downloads        :integer          default(0), not null
#  homepage_url     :string           not null
#  issues_url       :string           not null
#  name             :string           not null
#  slug             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  superseded_by_id :bigint
#  user_id          :bigint           not null
#
# Indexes
#
#  index_openvox_modules_on_slug              (slug) UNIQUE
#  index_openvox_modules_on_superseded_by_id  (superseded_by_id)
#  index_openvox_modules_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (superseded_by_id => openvox_modules.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class OpenVoxModuleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
