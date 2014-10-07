require "test_helper"

class RadpostauthTest < ActiveSupport::TestCase

  def radpostauth
    @radpostauth ||= Radpostauth.new
  end

  def test_valid
    assert radpostauth.valid?
  end

end
