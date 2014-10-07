require "test_helper"

class RadcheckTest < ActiveSupport::TestCase

  def radcheck
    @radcheck ||= Radcheck.new
  end

  def test_valid
    assert radcheck.valid?
  end

end
