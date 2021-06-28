ENV['RAILS_ENV'] = 'test'
require_relative "../config/environment"
require "rails/test_help"
require 'database_cleaner'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean_with(:truncation)

class ActiveSupport::TestCase
	self.use_transactional_tests = true
	ActiveRecord::Migration.check_pending!

	def setup
		DatabaseCleaner.start
	end

	def teardown
		DatabaseCleaner.clean
	end

	# Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
	#
	# Note: You'll currently still have to declare fixtures explicitly in integration tests
	# -- they do not yet inherit this setting
	fixtures :all

	# Add more helper methods to be used by all tests here...
end

def execute_sql(query)
	ActiveRecord::Base.connection.execute(query)
end


def assert_change(what)
	old = what.call
	yield
	assert_not_equal old, what.call
end

def assert_no_change(what)
	old = what.call
	yield
	assert_equal old, what.call
end

