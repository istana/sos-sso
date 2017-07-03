require "test_helper"

class RadcheckTest < ActiveSupport::TestCase

  def radcheck
    @user = User.new
    @radcheck ||= Radcheck.new(user: @user)
  end

  def test_valid
    assert radcheck.valid?
  end

end
