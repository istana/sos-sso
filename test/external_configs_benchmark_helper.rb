require 'ffaker'
require 'securerandom'

module ExternalConfigsHelper
	def random_groups(how_many)
		Group.order("RAND()").limit(how_many)
	end
	
	def random_group
		random_groups(1).first
	end

	def generate_nss_dataset(users = 100, groups = 50)
		# setup cca 1000 users, 100 groups and 1000 aliases
		if Group.count < groups
			groups.times do
				g = Group.create(name: FFaker::Lorem.word + SecureRandom.uuid)
				@group_ids ||= []
				@group_names ||= []
				@group_names << g.name
				@group_ids << g.id
			end
		end

		foouser = false

		if User.count < users
			users.times do
				# mysql only, maybe postre would work, sqlite not
				username = if !foouser
										 foouser = true
										 "foouser"
										else
											FFaker::Internet.user_name + SecureRandom.uuid
										end
				user = User.create(username: username, gid: random_group.id, homedir: '/home/blah')

				# add some secondary groups to user
				# possible bug, when user don't belong to some group, especially primary
				user.groups << random_groups(rand(15))

				@user_ids ||= []
				@user_ids << user.id
				@user_names ||= []
				@user_names << user.username
			end
		end
	end
end	
