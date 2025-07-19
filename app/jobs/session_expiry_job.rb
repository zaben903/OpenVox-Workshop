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

# Deletes old sessions periodically.
# Deletes `remember_me: false` sessions after 1 day.
# Deletes `remember_be: true` sessions after 3 months.
class SessionExpiryJob < ApplicationJob
  queue_as :low

  def perform
    Session.where(remember_me: false, updated_at: ..1.day.ago).delete_all
    Session.where(remember_me: true, updated_at: ..3.months.ago).delete_all
  end
end
