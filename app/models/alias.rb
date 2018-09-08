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

class Alias < ApplicationRecord
	belongs_to :user, inverse_of: :aliases

	has_paper_trail

	rails_admin do
		list do
			exclude_fields :created_at
	
			field :updated_at do
				strftime_format "%Y-%m-%d"
			end
		end
	end
end
