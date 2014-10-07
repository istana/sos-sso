require "test_helper"
require "external_configs"

# this class tests if SQL commands are ok
class PostfixAliasesCommandsTest < ActiveSupport::TestCase
	def setup
		@aliases = ExternalConfigs.read_postfix(File.join(Rails.root, "external_configs", "postfix", "postfix-mysql-aliases.cf"))

		@fouser = get_users('fouser')
		@fouser_raw = get_users_raw('fouser')
	end

	# gets user from alias
	def get_users(al)
		 User.joins(:aliases, :groups).where(:'aliases.name' => al, :'aliases.active' => 1,
																				 :'groups.name' => 'mail', :'users.active' => 1).pluck(:username)
	end

	def get_users_raw(al)
		execute_sql(@aliases["query"].gsub('%s', al))
	end

	def test_active_alias_active_user_mail
		assert_equal true, @fouser_raw.to_a.include?(['foouser'])
		assert_equal true, @fouser.to_a.include?('foouser')
	end

	def test_active_alias_active_user_nomail
		assert_equal false, @fouser_raw.to_a.include?(['bazuser'])
		assert_equal false, @fouser.to_a.include?('bazuser')
	end

	def test_active_alias_noactive_user_mail
		assert_equal false, @fouser_raw.to_a.include?(['zoouser'])
		assert_equal false, @fouser.to_a.include?('zoouser')
	end

	def test_active_alias_noactive_user_nomail
		User.find_by(username: 'zoouser').groups.delete(name: 'mail')

		assert_equal false, @fouser_raw.to_a.include?(['zoouser'])
		assert_equal false, @fouser.to_a.include?('zoouser')
	end

	def test_noactive_alias_active_user_mail
		assert_equal false, @fouser_raw.to_a.include?(['baruser'])
		assert_equal false, @fouser.to_a.include?('baruser')	
	end

	def test_noactive_alias_active_user_nomail
		User.find_by(username: 'baruser').groups.delete(name: 'mail')

		assert_equal false, @fouser_raw.to_a.include?(['baruser'])
		assert_equal false, @fouser.to_a.include?('baruser')
	end

	def test_noactive_alias_noactive_user_mail
		User.find_by(username: 'baruser').update(active: false)

		assert_equal false, @fouser_raw.to_a.include?(['baruser'])
		assert_equal false, @fouser.to_a.include?('baruser')
	end

	def test_noactive_alias_noactive_user_nomail
		bar = User.find_by(username: 'baruser')
		bar.update(active: false)
		bar.groups.delete(name: 'mail')

		assert_equal false, @fouser_raw.to_a.include?(['baruser'])
		assert_equal false, @fouser.to_a.include?('baruser')
	end
end

