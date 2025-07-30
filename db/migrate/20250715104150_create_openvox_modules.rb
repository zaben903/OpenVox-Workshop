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

class CreateOpenVoxModules < ActiveRecord::Migration[8.0]
  def change
    create_table :openvox_modules do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.string :description, null: false
      t.integer :downloads, default: 0, null: false
      t.timestamp :deprecated_at
      t.string :deprecated_for
      t.string :homepage_url, null: false
      t.string :issues_url, null: false
      t.boolean :deleted, default: false

      t.timestamps

      t.references :user, null: false, foreign_key: true
      t.references :superseded_by, foreign_key: {to_table: :openvox_modules}
    end
    add_index :openvox_modules, :slug, unique: true
  end
end
