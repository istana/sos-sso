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

# Rails incorrectly loads assoc via Radpostauth.all.includes(:user) when username here has different capitalization
# but Radpostauth.where(username: 'Cat') correctly searches for 'cat' and 'Cat'
#	belongs_to :user, inverse_of: :radius_auths,
#   :foreign_key => :username, :primary_key => :username
end

