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
#  downloads        :integer
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
class OpenVoxModule < ApplicationRecord
  belongs_to :user
  has_many :releases, dependent: :destroy
  has_one :superseded_by, class_name: "OpenVoxModule", foreign_key: "superseded_by_id"

  scope :active, -> { where(deleted: false) }

  before_validation :set_slug

  validates :slug, presence: true, uniqueness: true, format: {with: /\A[a-zA-Z0-9]+[-\/][a-z][a-z0-9_]*\z/}
  validates :name, presence: true, format: {with: /\A[a-z][a-z0-9_]*\z/}
  validates :homepage_url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[http https])}
  validates :issues_url, presence: true, format: {with: URI::DEFAULT_PARSER.make_regexp(%w[http https])}
  validates :deprecated_for, presence: true, if: :deprecated_at?
  validate :ensure_not_deleted

  # Marks the module as deleted, hiding it from the Web UI but still allowing files to be downloaded.
  #
  # @param reason [String] Reason why the module is being deleted
  def soft_delete!(reason:)
    update!(deleted: true, deprecated_at: Time.zone.now, deprecated_for: reason)
  end

  # Converts the OpenVoxModule to the format expected by the V3 Forge API
  #
  # @param include_fields [Array<String>] List of fields that should be returned
  # @param exclude_fields [Array<String>] List of fields that should be excluded
  #
  # @return [Hash]
  #
  # @todo Might need to look at a better way of filtering fields before going to the database for no reason.
  def to_forgeapi(include_fields: [], exclude_fields: [])
    openvox_module = {
      uri: Rails.application.routes.url_helpers.api_v3_module_path(slug),
      slug: slug,
      name: name,
      downloads: releases.sum(:downloads),
      created_at: created_at.iso8601,
      updated_at: updated_at.iso8601,
      deprecated_at: deprecated_at&.iso8601,
      deprecated_for: deprecated_for,
      superseded_by: superseded_by ? {
        uri: Rails.application.routes.url_helpers.api_v3_module_path(superseded_by.slug),
        slug: superseded_by.slug
      } : nil,
      supported: false,
      endorsement: nil,
      module_group: "base",
      premium: false,
      owner: user.to_forgeapi_abbreviated,
      current_release: releases.order(:id).last&.to_forgeapi,
      releases: releases.order(:id).map(&:to_forgeapi_abbreviated),
      feedback_score: 0,
      homepage_url: homepage_url,
      issues_url: issues_url
    }

    openvox_module.reject! { |k, _| !include_fields.include?(k.to_s) } unless include_fields.empty?
    openvox_module.reject! { |k, _| exclude_fields.include?(k.to_s) } unless exclude_fields.empty?

    openvox_module
  end

  # Converts the OpenVoxModule to the format expected by the V3 Forge API
  #
  # @return [Hash]
  def to_forgeapi_abbreviated
    {
      uri: Rails.application.routes.url_helpers.api_v3_module_path(slug),
      slug: slug,
      name: name,
      deprecated_at: deprecated_at&.iso8601,
      owner: user.to_forgeapi_abbreviated
    }
  end

  private

  # Set the slug based on the user slug and module name
  def set_slug
    self.slug ||= "#{user.username}-#{name}"
  end

  # Checks if the module has been marked as deleted. If it has raise error if changes are attempted
  def ensure_not_deleted
    if deleted? && changed? && !deleted_changed?
      errors.add(:base, "This module has been marked as deleted and cannot be modified.")
    end
  end
end
