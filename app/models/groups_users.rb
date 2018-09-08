# == Schema Information
#
# Table name: groups_users
#
#  group_id :integer          not null
#  user_id  :integer          not null
#

require 'radius_tasks'

class GroupsUsers < ApplicationRecord
	belongs_to :user
	belongs_to :group

	before_save :update_radius_user

	def update_radius_user
		RadiusTasks.synchronize_account(self.user)
	end
end
