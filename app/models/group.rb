class Group < ActiveRecord::Base
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
