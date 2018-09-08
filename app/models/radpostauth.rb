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

class Radpostauth < ApplicationRecord
	self.table_name = "radpostauth"

	belongs_to :user, inverse_of: :radius_users,
		:foreign_key => :username, :primary_key => :username
end

