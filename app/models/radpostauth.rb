class Radpostauth < ApplicationRecord
	self.table_name = "radpostauth"

	belongs_to :user, inverse_of: :radius_users,
		:foreign_key => :username, :primary_key => :username
end

