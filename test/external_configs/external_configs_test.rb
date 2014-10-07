require "test_helper"
require "external_configs"

require 'fileutils'

class ReadConfigTest < MiniTest::Test
	def setup
		@testfile = 'xxxtest.cf'
		File.write(@testfile, "foo = bar\n\n#comment\nbaz = zoo\n\nuuu = SELECT x \\\nFROM users\\\nWHERE foo = \"%s\";\n")

		@testfile_complex = 'xxxtest_complex.cf'
		File.write(@testfile_complex, "getpwnam    SELECT username,'x',uid,gid,gecos,homedir,shell \\\n            FROM users \\\n            WHERE username='%1$s' \\\n            LIMIT 1\n")

		@testfile_postfix = 'xxxtest_postfix.cf'
		File.write(@testfile_postfix, "query = SELECT users.username\n        FROM users\n        INNER JOIN aliases ON users.id = aliases.user_id\nkey = value")
	end

	def teardown
		# TODO change location to test/tmp
		FileUtils.rm(@testfile) if File.exists?(@testfile)
		FileUtils.rm(@testfile_complex) if File.exists?(@testfile_complex)
		FileUtils.rm(@testfile_postfix) if File.exists?(@testfile_postfix)
	end

	def test_read
		r = ExternalConfigs.read(@testfile)
		assert_equal({"foo" => "bar", "baz" => "zoo", "uuu" => 'SELECT x FROM users WHERE foo = "%s";'}, r)
	end

	def test_read_complex
		r = ExternalConfigs.read(@testfile_complex, " ")
		assert_equal({"getpwnam" => "SELECT username,'x',uid,gid,gecos,homedir,shell FROM users WHERE username='%1$s' LIMIT 1"}, r)
	end

	def test_read_libnss
		r = ExternalConfigs.read_libnss(@testfile_complex)
		assert_equal({"getpwnam" => "SELECT username,'x',uid,gid,gecos,homedir,shell FROM users WHERE username='%1$s' LIMIT 1"}, r)
	end

	def test_postfix
		r = ExternalConfigs.read_postfix(@testfile_postfix)
		assert_equal({"query" => "SELECT users.username FROM users INNER JOIN aliases ON users.id = aliases.user_id", "key" => "value"}, r)
	end
end

