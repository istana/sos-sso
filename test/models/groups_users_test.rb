require "test_helper"

class GroupsUsersTest < ActiveSupport::TestCase

  def groups_users
    @groups_users ||= GroupsUsers.new
  end

  def test_valid
    assert groups_users.valid?
  end

end
