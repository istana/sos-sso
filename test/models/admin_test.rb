# == Schema Information
#
# Table name: admins
#
#  id                  :bigint(8)        not null, primary key
#  email               :string(255)      default(""), not null
#  encrypted_password  :string(255)      default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

require "test_helper"

class AdminTest < ActiveSupport::TestCase
=begin
  def admin
    @admin ||= Admin.new
  end

  def test_valid
    assert admin.valid?
  end
=end
end
