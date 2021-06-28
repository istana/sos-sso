require "test_helper"

class SystemsTasksUsersTest < ActiveSupport::TestCase

	def setup
		@path = FileUtils.mkdir_p(File.join(Rails.root, 'test', 'tmp')).first
		@test_dir = FileUtils.mkdir(File.join(@path, "test_dir")).first
		@test_file = File.join(@path, "test_file")
		File.write(@test_file, "")

		@foouser = User.find_by(username: 'foouser')
		@foouser.update(homedir: @test_dir)
	end

	def teardown
		FileUtils.rm_rf(@path) if @path && File.exist?(@path)
	end

	test 'redundant_homedirs' do
		dirs = SystemTasks::Users.redundant_homedirs(@path)

		assert_equal true, dirs.include?(@test_file)
	end

	test 'missing_homedirs' do
		dirs = SystemTasks::Users.missing_homedirs

		assert_equal false, dirs.flatten.include?("foouser")
	end

	test 'missing_homedirs: homedir is a file' do
		@foouser.update(homedir: @test_file)
		dirs = SystemTasks::Users.missing_homedirs

		assert_equal true, dirs.include?(['foouser', 'file'])
	end

	test 'homedirs_check_permissions' do
		#TODO
	end

	test 'redundant_missing_samba_users' do
# TODO how to fake system call?
#		samba_users = File.read(File.join(Rails.root, 'test', 'fixtures', '_pdbedit_l.txt'))
#		users = User.all.to_a
#		users.delete(@foouser)

#		redundant, missing = SystemTasks::Users.redundant_missing_samba_users(samba_users)

#		assert_equal ['geralt', 'sheppard', 'riddick', 'xardas'], redundant
#		assert_equal users.map(&:username), missing
	end

	test 'weak hash function in password' do
		User.all.each do |u|
			u.update_attribute('password', 'x')
		end

		@foouser.update_attribute('password', '$1$salt$password123')

		@baruser = User.find_by(username: 'baruser')
		@baruser.update_attribute('password', '$6$salt$password123')

		@bazuser = User.find_by(username: 'bazuser')
		@bazuser.update_attribute('password', '$2a$salt$password123')

		weak = SystemTasks::Users.weak_hash_function_in_password
		assert_equal ['foouser'], weak
	end
end

