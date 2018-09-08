# == Schema Information
#
# Table name: groups
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)      not null
#  password   :string(255)      default("x"), not null
#  created_at :datetime
#  updated_at :datetime
#

class Group < ApplicationRecord
	has_and_belongs_to_many :users, inverse_of: :groups

	has_paper_trail

	def default_values
		if !self.persisted?
			self.password = 'x'
		end
	end

	rails_admin do
		list do
			exclude_fields :created_at

			field :updated_at do
				strftime_format "%Y-%m-%d"
			end
		end

		exclude_fields :password

	end
end
