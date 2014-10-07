require "test_helper"
require "password_generator"

# TODO: extend tests
class PasswordGeneratorTest < ActiveSupport::TestCase
	test 'rememberable password' do
		pw = PasswordGenerator.rememberable(8)
		puts pw.inspect
		assert_equal 8, pw.length
	end
end

