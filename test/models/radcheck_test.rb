# == Schema Information
#
# Table name: radcheck
#
#  id       :bigint(8)        not null, primary key
#  username :string(255)      default(""), not null
#  attr     :string(255)      default(""), not null
#  op       :string(2)        default("=="), not null
#  value    :string(255)      default(""), not null
#

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
