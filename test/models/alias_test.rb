# == Schema Information
#
# Table name: aliases
#
#  id         :bigint(8)        not null, primary key
#  active     :boolean          default(TRUE), not null
#  name       :string(255)      not null
#  user_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class AliasTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
