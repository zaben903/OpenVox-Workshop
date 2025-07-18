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

class CreateReleases < ActiveRecord::Migration[8.0]
  def change
    create_table :releases do |t|
      t.references :openvox_module, null: false, foreign_key: true
      t.string :slug, null: false
      t.string :version, null: false
      t.integer :downloads
      t.timestamp :deleted_at
      t.string :deleted_for

      # Information from upload
      t.integer :file_size, null: false
      t.string :file_md5, null: false
      t.string :file_sha256, null: false
      t.string :readme
      t.string :changelog
      t.string :license
      t.string :reference
      t.json :metadata, null: false

      t.timestamps
    end
    add_index :releases, :slug, unique: true
    add_index :releases, [:openvox_module_id, :version], unique: true
  end
end
