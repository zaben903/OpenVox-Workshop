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
# @todo Identify when PDK is being used.
# @todo Identify available tasks
# @todo Identify available plans
class Release < ApplicationRecord
  belongs_to :openvox_module
  has_one :user, through: :openvox_module
  has_one_attached :file

  scope :active, -> { where(deleted_at: nil) }

  before_validation :set_slug

  validates :slug, presence: true, uniqueness: true, format: {with: /\A[a-zA-Z0-9]+[-\/][a-z][a-z0-9_]*[-\/][0-9]+\.[0-9]+\.[0-9]+([\-+].+)?\z/}
  validates :version, presence: true, uniqueness: {scope: :openvox_module_id}, format: {with: /\A\d+\.\d+\.\d+\z/}
  validates :file_md5, presence: true
  validates :file_sha256, presence: true
  validates :file_size, presence: true
  validates :metadata, presence: true

  # Converts the Release to the format expected by the V3 Forge API
  #
  # @param include_fields [Array<String>] List of fields that should be returned
  # @param exclude_fields [Array<String>] List of fields that should be excluded
  #
  # @return [Hash]
  #
  # @todo Might need to look at a better way of filtering fields before going to the database for no reason.
  def to_forgeapi(include_fields: [], exclude_fields: [])
    release = {
      uri: Rails.application.routes.url_helpers.api_v3_module_path(slug),
      slug: slug,
      module: openvox_module.to_forgeapi_abbreviated,
      version: version,
      metadata: metadata,
      tags: metadata["tags"],
      pdk: false,
      validation_score: 0,
      file_uri: Rails.application.routes.url_helpers.url_for(file),
      file_size: file_size,
      file_md5: file_md5,
      file_sha256: file_sha256,
      downloads: downloads,
      readme: readme,
      changelog: changelog,
      license: license,
      reference: reference,
      pe_compatiblity: nil,
      tasks: [],
      plans: [],
      created_at: created_at,
      updated_at: updated_at,
      deleted_at: deleted_at,
      deleted_for: deleted_for
    }

    release.reject! { |k, _| !include_fields.include?(k.to_s) } unless include_fields.empty?
    release.reject! { |k, _| exclude_fields.include?(k.to_s) } unless exclude_fields.empty?

    release
  end

  # Converts the Release to the format expected by the V3 Forge API
  #
  # @return [Hash]
  def to_forgeapi_abbreviated
    {
      uri: Rails.application.routes.url_helpers.api_v3_module_path(slug),
      slug: slug,
      version: version,
      created_at: created_at,
      deleted_at: deleted_at,
      file_uri: Rails.application.routes.url_helpers.url_for(file),
      file_size: file_size
    }
  end

  private

  # Set the slug based on the module slug and module name
  def set_slug
    self.slug ||= "#{openvox_module.slug}-#{version}"
  end
end
