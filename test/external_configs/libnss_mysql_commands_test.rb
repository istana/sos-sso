require "test_helper"
require "external_configs"

# this class tests if SQL commands are ok
class LibnssMysqlCommandsTest < ActiveSupport::TestCase
	def setup
		@nss = ExternalConfigs.read_libnss(File.join(Rails.root, "external_configs", "libnss", "libnss-mysql.cfg"))
	end

	def validate_pwd(userraw, user)
		assert_equal user.username, userraw[0]
		assert_equal "x", userraw[1]
		assert_equal user.id, userraw[2]
		assert_equal user.gid, userraw[3]
		assert_equal user.gecos, userraw[4]
		assert_equal user.homedir, userraw[5]
		assert_equal user.shell, userraw[6]
	end

	def validate_group(groupraw, group)
		assert_equal group.name, groupraw[0]
		assert_equal group.password, groupraw[1]
		assert_equal group.id, groupraw[2]
	end

	def validate_shadow(userraw, user)
		%w{username password lstchg min max warn inact expire flag}.each_with_index do |attr, i|
			assert_equal user.send(attr), userraw[i], "Attribute: '#{attr}'"
		end
	end
# todo more tests
	def test_getpwnam
		result = execute_sql(@nss["getpwnam"].gsub('%1$s', 'foouser'))
		user = User.find_by(username: 'foouser')

		assert_equal 1, result.count
		assert_not_nil user
		validate_pwd(result.first, user)

		# not active
		result = execute_sql(@nss["getpwnam"].gsub('%1$s', 'zoouser'))
		assert_equal 0, result.count

		# does not have gid group in groups
		result = execute_sql(@nss["getpwnam"].gsub('%1$s', 'aaauser'))
		assert_equal 0, result.count
	end

	def test_getpwuid
		user = User.find_by(username: 'foouser')
		result = execute_sql(@nss["getpwuid"].gsub('%1$u', user.id.to_s))

		assert_equal 1, result.count
		assert_not_nil user
		validate_pwd(result.first, user)
	end

	def test_getspnam
		user = User.find_by(username: 'foouser')
		result = execute_sql(@nss["getspnam"].gsub('%1$s', user.username))

		assert_equal 1, result.count
		assert_not_nil user
		validate_shadow(result.first, user)
	end

	def test_getpwent
		result = execute_sql(@nss["getpwent"])
		users = User.where(active: 1).to_a.keep_if{|u| u.groups.map(&:id).include?(u.gid)}

		assert_equal users.count, result.count
		validate_pwd(result.first, users.first)
		validate_pwd(result.to_a[1], users[1])
	end

	def test_getspent
		result = execute_sql(@nss["getspent"])
		users = User.all

		assert_equal User.all.count, result.count
		assert_equal User.all.count, users.count
		validate_shadow(result.first, users.first)
		validate_shadow(result.to_a[1], users[1])	
	end

	def test_getgrnam
		result = execute_sql(@nss["getgrnam"].gsub("%1$s", "admin"))
		group = Group.find_by(name: 'admin')

		assert_equal 1, result.count
		validate_group(result.first, group)
	end

	def test_getgrgid
		group = Group.find_by(name: 'admin')
		result = execute_sql(@nss["getgrgid"].gsub("%1$u", group.id.to_s))

		assert_equal 1, result.count
		validate_group(result.first, group)
	end

	def test_getgrent
		result = execute_sql(@nss["getgrent"])
		groups = Group.all

		assert_equal 7, result.count
		assert_equal 7, groups.count

		validate_group(result.first, groups.first)
		validate_group(result.to_a[1], groups[1])
	end

	def test_memsbygid_admin
		admin = Group.find_by(name: 'admin')
		assert_not_nil admin

		members = admin.users.map(&:username)
		members_raw = execute_sql(@nss["memsbygid"].gsub("%1$u", admin.id.to_s))

		assert_equal 2, members_raw.count
		assert_equal 2, members.count
		assert_equal members.sort,members_raw.to_a.flatten.sort
	end

	def test_memsbygid_4a
		g4a = Group.find_by(name: '4.A')
		assert_not_nil g4a

		members = g4a.users.map(&:username)
		members_raw = execute_sql(@nss["memsbygid"].gsub("%1$u", g4a.id.to_s))

		assert_equal 2, members_raw.count
		assert_equal 2, members.count
		assert_equal members, members_raw.to_a.flatten
	end

	def test_gidsbymem_foouser
		foouser = User.find_by(username: "foouser")
		assert_not_nil foouser

		gids = foouser.groups.map(&:id)
		gids_raw = execute_sql(@nss["gidsbymem"].gsub("%1$s", foouser.username))

		assert_equal 5, gids.count
		assert_equal 5, gids_raw.count
		assert_equal gids.sort, gids_raw.to_a.flatten.sort
	end

end

