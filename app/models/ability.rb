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

# Defines what actions a User can take
class Ability
  include CanCan::Ability

  def initialize(user)
    public_users

    authenticated_users(user) if user.present?
  end

  private

  def public_users
    can :read, OpenVoxModule
    can :read, Release
    can :read_public, User
  end

  def authenticated_users(user)
    can :manage, OpenVoxModule, user: user
    can :manage, Release, openvox_module: {user: user}
    can :manage, User, id: user.id
  end
end
