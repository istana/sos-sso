# == Schema Information
#
# Table name: users
#
#  id            :bigint(8)        not null, primary key
#  username      :string(255)      not null
#  gid           :bigint(8)        not null
#  gecos         :string(255)      default(""), not null
#  homedir       :string(255)      not null
#  shell         :string(255)      default("/usr/bin/rssh"), not null
#  password      :string(255)      default("x"), not null
#  lstchg        :bigint(8)        default(1), not null
#  min           :bigint(8)        default(0), not null
#  max           :bigint(8)        default(9999), not null
#  warn          :bigint(8)        default(30), not null
#  inact         :bigint(8)        default(0), not null
#  expire        :bigint(8)        default(-1), not null
#  flag          :integer          default(0), not null
#  quota_mass    :bigint(8)        default(52428800), not null
#  quota_inodes  :bigint(8)        default(15000), not null
#  active        :boolean          default(TRUE), not null
#  created_at    :datetime
#  updated_at    :datetime
#  ntlm_password :string(255)
#

require "test_helper"

class UserTest < ActiveSupport::TestCase

	def setup
		@foouser = User.find_by(username: 'foouser')
		@baruser = User.find_by(username: 'baruser')
		@zoouser = User.find_by(username: 'zoouser')

		@factory = @foouser.as_json
		@factory.delete("id")
	end

	test 'is valid' do
		assert_equal true, @foouser.valid?
		assert_equal true, @baruser.valid?
		assert_equal true, @zoouser.valid?
	end

	test 'sanity' do
		# I'm not testing for respond_to?, but call
		# directly to check if association is OK
		# there used to be lots of mistakes
		# should be (empty) array
		refute_nil @foouser.groups
		refute_nil @foouser.aliases
		refute_nil @foouser.radius_users

		refute_nil @foouser.primary_group
	end

	## USERNAME + GECOS

	test 'username is unique' do
		user = User.new(@factory)

		assert_equal false, user.valid?
		assert_equal true, user.errors.include?(:username)
	end

	test 'persons with the same name gets different usernames' do
		@factory.delete("username")
		@factory["fullname"] = "Ariana Grande"

		user1 = User.create!(@factory)
		user2 = User.create!(@factory)

		assert_not_equal user1.username, user2.username
		assert_equal "xgrandea", user1.username
		assert_equal "xgrandea1", user2.username
	end

	test '#generate_username, username is generated from GECOS fullname' do
		@factory.delete("username")
		@factory["fullname"] = "Ariana Grande"

		user = User.new(@factory)

		assert_equal true, user.valid?
		assert_equal "xgrandea", user.username

		# person with more names
		@foouser.fullname = "Radúz Vasco de Ňuňéz"
		@foouser.username = nil
		assert_equal 'xnunezdvr', @foouser.generate_username
	end

	test '#generate_username, username is generated from GECOS fullname (management)' do
		@factory.delete("username")
		@factory["fullname"] = "Ariana Grande"

		user = User.new(@factory)
		user.groups << Group.find_by(name: "management")

		assert_equal true, user.valid?
		assert_equal "grande", user.username
	end

	test '#uniq_username' do
		assert_equal 'foouser1', User.new.uniq_username('foouser')
		assert_equal 'notindb', User.new.uniq_username('notindb')

		@factory["username"] = "foouser1"
		User.create!(@factory)
		assert_equal 'foouser2', User.new.uniq_username('foouser1')

		blueprint = @foouser.as_json
		blueprint.delete("id")
		blueprint.delete("username")
		blueprint["fullname"] = "Ariana Grande"

		User.create!(blueprint)

		1.upto(49) do |i|
			u = User.create!(blueprint)
			assert_equal "xgrandea#{i}", u.username
		end

		refute_equal "xgrande50", User.new.uniq_username('xgrande')
		assert_match(/\Axgrandea-[0-9a-f]+\z/, User.new.uniq_username('xgrandea'))
	end

	test 'GECOS' do
		@foouser.update(gecos: 'Foo User,IT dept.,123456,foo@example.org')

		assert_equal 'Foo User', @foouser.fullname
		assert_equal 'IT dept.', @foouser.section
		assert_equal '123456', @foouser.phone
		assert_equal 'foo@example.org', @foouser.email

		@foouser.fullname = "Ariana Grande"
		assert_equal "Ariana Grande", @foouser.fullname

		@foouser.section = "management"
		assert_equal "management", @foouser.section

		@foouser.phone = "123456"
		assert_equal "123456", @foouser.phone

		@foouser.email = "ariana@example.org"
		assert_equal "ariana@example.org", @foouser.email
	end

	## PASSWORD
	# TODO: rename password to crypt_password
	test 'set cleartext password' do

		assert_change(-> {@foouser.password}) do
			@foouser.password_cleartext = 'foobar123'
		end

		assert_change(-> {@foouser.ntlm_password}) do
			@foouser.password_cleartext = 'foobar1234'
		end

		assert_operator 32, :<=, @foouser.ntlm_password.length
		assert_match(/\A[A-Z0-9]+\z/, @foouser.ntlm_password)

		# SHA512 has 83 chars (and is encoded in Base64)
		assert_operator @foouser.password.length, :>=, 80
	end

	test 'generate password when requested' do
		@factory["generate_password"] = 1
		@factory["username"] = "grande"
		@factory.delete("ntlm_hash")
		@factory.delete("password")
		@factory.delete("password_cleartext")

		u = User.create(@factory)

		assert_equal true, u.valid?
		assert_equal false, u.password.blank?
		assert_equal false, u.ntlm_password.blank?

		assert_nothing_raised { u.save! }

		# generate password for existing record
		assert_change(-> {u.password}) do
			u.generate_password = true
			u.save!
		end
	end

	test 'do not generate password when not requested' do
		assert_no_change(-> {@foouser.password}) do
			@foouser.generate_password = false
			@foouser.save!
		end
	end

	## HOMEDIR

	test 'generate save homedir' do
		@foouser.homedir = nil
		assert_equal true, @foouser.valid?
		assert_match Regexp.new(@foouser.username), @foouser.homedir
	end

	## RADIUS sync

	test 'radius_users association' do
		@foouser.save!

		assert_equal @foouser.radius_users, Radcheck.where(username: 'foouser')
	end

	test 'radius synchronization after save' do
		@foouser.save
		# others are not active or in wifi group
		@baruser.save
		@zoouser.save

		assert_equal @foouser.radius_users, Radcheck.all

		crypt_passwords = @foouser.radius_users.where(attr: 'Crypt-Password')
		ntlm_passwords = @foouser.radius_users.where(attr: 'NT-Password')

		assert_equal 1, crypt_passwords.count
		assert_equal 1, ntlm_passwords.count

		assert_equal @foouser.password, crypt_passwords.first.value
		assert_equal @foouser.ntlm_password, ntlm_passwords.first.value
	end

	## DEPENDENT DESTROY hooks

end
