require "test_helper"

# TODO: extend tests
class PasswordGeneratorTest < ActiveSupport::TestCase
	test 'rememberable password' do
		pw = PasswordGenerator.rememberable(8)
		assert_equal 8, pw.length
	end
end

