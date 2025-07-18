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
# Table name: users
#
#  id              :bigint           not null, primary key
#  display_name    :string           not null
#  email_address   :string           not null
#  password_digest :string           not null
#  username        :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#  index_users_on_username       (username) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :openvox_modules, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :username, presence: true, uniqueness: true, format: {with: /\A[a-zA-Z0-9]+\z/}
  validates :display_name, presence: true

  # Converts the User to the format expected by the V3 Forge API
  #
  # @param include_fields [Array<String>] List of fields that should be returned
  # @param exclude_fields [Array<String>] List of fields that should be excluded
  #
  # @return [Hash]
  #
  # @todo Might need to look at a better way of filtering fields before going to the database for no reason.
  def to_forgeapi(include_fields: [], exclude_fields: [])
    user = {
      uri: Rails.application.routes.url_helpers.api_v3_user_path(username),
      slug: username,
      gravatar_id: nil,
      username: display_name,
      display_name: display_name,
      release_count: openvox_modules.collect { |m| m.releases.count }.sum,
      module_count: openvox_modules.count,
      created_at: created_at,
      updated_at: updated_at
    }

    user.reject! { |k, _| !include_fields.include?(k.to_s) } unless include_fields.empty?
    user.reject! { |k, _| exclude_fields.include?(k.to_s) } unless exclude_fields.empty?

    user
  end

  # Converts the User to the format expected by the V3 Forge API
  #
  # @return [Hash]
  def to_forgeapi_abbreviated
    {
      uri: Rails.application.routes.url_helpers.api_v3_user_path(username),
      slug: username,
      username: display_name,
      gravatar_id: nil
    }
  end
end
