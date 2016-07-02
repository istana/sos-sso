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
