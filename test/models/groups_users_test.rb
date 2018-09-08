# == Schema Information
#
# Table name: groups_users
#
#  group_id :integer          not null
#  user_id  :integer          not null
#

require "test_helper"

class GroupsUsersTest < ActiveSupport::TestCase

  def groups_users
    @group = Group.new
    @user = User.new
    @groups_users ||= GroupsUsers.new(user: @user, group: @group)
  end

  def test_valid
    assert groups_users.valid?
  end

end
