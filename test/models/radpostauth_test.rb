require "test_helper"

class RadpostauthTest < ActiveSupport::TestCase

  def radpostauth
    @user = User.new
    @radpostauth ||= Radpostauth.new(user: @user)
  end

  def test_valid
    assert radpostauth.valid?
  end

end
