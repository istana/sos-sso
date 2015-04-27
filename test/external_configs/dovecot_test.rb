require "test_helper"
require "external_configs"

# this class tests if SQL commands are ok
# TODO extend tests
class DovecotTest < ActiveSupport::TestCase
	def setup
		@dovecot = ExternalConfigs.read(File.join(Rails.root, "external_configs", "dovecot", "dovecot-sql.conf.ext"))
		@foouser = User.find_by(username: 'foouser')
	end

	test 'active_nomail_gid_exists' do
		mail_group = Group.find_by(name: 'mail')
		@foouser.groups.delete(mail_group)
		assert_equal true, @foouser.groups.map(&:id).include?(@foouser.gid)

		user_raw = execute_sql(@dovecot["user_query"].gsub("%u", 'foouser'))
		assert_equal [], user_raw.to_a
	end

	test 'active_mail_gid_not_exists' do
		# skip validation
		@foouser.update_attribute(:gid, 999999999)
		assert_equal true, @foouser.groups.map(&:name).include?('mail')
		assert_equal true, @foouser.active

		user_raw = execute_sql(@dovecot["user_query"].gsub("%u", 'foouser'))
		assert_equal [], user_raw.to_a
	end

	def test_user_query
		user_raw = execute_sql(@dovecot["user_query"].gsub("%u", 'foouser'))
		users = User.joins(:groups).where(username: 'foouser').where('groups.id = users.gid').pluck(:'users.homedir', :'users.id', :'users.gid')

		expected = [[@foouser.homedir, @foouser.id, @foouser.gid]]
		assert_equal expected, user_raw.to_a
		assert_equal expected, users
	end

	def test_password_query
		user_raw = execute_sql(@dovecot["password_query"].gsub("%u", 'foouser'))
		users = User.where(username: 'foouser').pluck(:username, :password, :homedir, :id, :gid)

		expected = [[@foouser.username, @foouser.password, @foouser.homedir, @foouser.id, @foouser.gid]]
		assert_equal expected, user_raw.to_a
		assert_equal expected, users.to_a
	end

	def test_iterate_query
		users_raw = execute_sql(@dovecot["iterate_query"])
		assert_equal ['baruser', 'foouser'], users_raw.to_a.flatten
	end
end
