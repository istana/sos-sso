# == Schema Information
#
# Table name: radpostauth
#
#  id       :bigint(8)        not null, primary key
#  username :string(255)      default(""), not null
#  pass     :string(255)      default(""), not null
#  reply    :string(255)      default(""), not null
#  authdate :datetime         not null
#

require "test_helper"

class RadpostauthTest < ActiveSupport::TestCase

  def radpostauth
#    @user = User.new
#    @radpostauth ||= Radpostauth.new(user: @user)
    @radpostauth = Radpostauth.new
  end

  def test_valid
    assert radpostauth.valid?
  end

end
