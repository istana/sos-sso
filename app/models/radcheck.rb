class Radcheck < ActiveRecord::Base
	self.table_name = "radcheck"

	# both foreign_key and primary_key are needed
	belongs_to :user, inverse_of: :radius_users,
		:foreign_key => :username, :primary_key => :username
end

