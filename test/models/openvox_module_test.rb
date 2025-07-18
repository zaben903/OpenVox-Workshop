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
require "test_helper"

class OpenVoxModuleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
