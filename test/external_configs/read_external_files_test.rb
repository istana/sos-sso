require "test_helper"
require "external_configs"

class ReadExternalFilesTest < MiniTest::Test
	def setup
		@conf_path = File.join(Rails.root, "external_configs")
	end

	def test_dovecot_keys
		@dovecot = ExternalConfigs.read(File.join(@conf_path, "dovecot-sql.conf.ext"))

		# just in case, maybe change later
		assert_operator 6, :>= , @dovecot.length

		%w{driver connect default_pass_scheme user_query password_query iterate_query}.each do |i|
			assert_equal true, @dovecot.include?(i)
		end
	end

	def test_postfix_aliases
		@postfix = ExternalConfigs.read_postfix(File.join(@conf_path, "postfix-mysql-aliases.cf"))

		%w{hosts user password dbname query}.each do |i|
			assert_equal true, @postfix.include?(i)
		end
		assert_operator 5, :>=, @postfix.length
	end

	def test_libnss_mysql_root
		@nss = ExternalConfigs.read_libnss(File.join(@conf_path, "libnss", "libnss-mysql-root.cfg"))

		assert_operator 2, :==, @nss.length
		assert_equal true, @nss.include?("username")
		assert_equal true, !@nss["username"].blank?
		assert_equal true, @nss.include?("password")
		assert_equal true, !@nss["password"].blank?
	end

	def test_libnss_mysql
		@nss = ExternalConfigs.read_libnss(File.join(@conf_path, "libnss", "libnss-mysql.cfg"))

		assert_operator 12, :<=, @nss.length

		%w{getpwnam getpwuid getspnam getpwent getgrnam getgrgid
		getgrent memsbygid gidsbymem} .each do |i|
			assert_equal true, @nss.include?(i)
			# check basic sanity of queries
			assert_equal 0, @nss[i] =~ /.*SELECT.*FROM.*/
		end

		%w{database username password}.each do |i|
			assert_equal true, @nss.include?(i)
		end
	end
end

