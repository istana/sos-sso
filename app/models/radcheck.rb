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

class Radcheck < ApplicationRecord
	self.table_name = "radcheck"

	# both foreign_key and primary_key are needed
	belongs_to :user, inverse_of: :radius_users,
		:foreign_key => :username, :primary_key => :username
end

