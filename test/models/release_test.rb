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
