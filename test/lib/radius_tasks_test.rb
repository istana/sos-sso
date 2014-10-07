require "test_helper"
require "radius_tasks"

class RadiusTasksTest < ActiveSupport::TestCase
	test 'synchronize_accounts' do
		RadiusTasks.synchronize_accounts
		# TODO remove aaauser, extend tests
		assert_equal ['aaauser', 'foouser'], Radcheck.where(attr: 'Crypt-Password').map(&:username).sort
		assert_equal ['aaauser', 'foouser'], Radcheck.where(attr: 'NT-Password').map(&:username).sort

		Radcheck.where(attr: 'Crypt-Password').each do |u|
			assert_match(/(\$\d\$.+)|x/, u.value)
		end

		Radcheck.where(attr: 'NT-Password').each do |u|
			assert_match(/[A-F0-9]+/, u.value)
		end
	end

	test 'synchronize user' do
		foouser = User.find_by(username: 'foouser')
		bazuser = User.find_by(username: 'bazuser')
		zoouser = User.find_by(username: 'zoouser')

		RadiusTasks.synchronize_account(foouser)
		RadiusTasks.synchronize_account(bazuser)
		RadiusTasks.synchronize_account(zoouser)

		assert_equal ['foouser'], Radcheck.where(attr: 'Crypt-Password').map(&:username)
		assert_equal ['foouser'], Radcheck.where(attr: 'NT-Password').map(&:username)
	end
end
