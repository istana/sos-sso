require 'test_helper'
require 'rails/performance_test_help'
require 'external_configs'
require 'external_configs_benchmark_helper'

class LibnssMysqlTest
	include ExternalConfigsHelper

	def setup
		DatabaseCleaner.clean
		@nss = ExternalConfigs.read_libnss(File.join(Rails.root, "external_configs", "libnss", "libnss-mysql.cfg"))
		generate_nss_dataset(1000, 1000)
	end

	def execute_sql(query)
		ActiveRecord::Base.connection.execute(query)
	end

	def run
		require 'benchmark'
		n = 50000

		puts "", '*** Welcome to the libnss-mysql benchmark, mortal! ***'
		puts '** 50 000 iterations, 5s ~ 10 000 iterations per second **'
		puts '***', ""

		Benchmark.bm(7) do |x|
			x.report("getpwnam") { n.times do execute_sql(@nss["getpwnam"].gsub('%1$s', @user_names.sample)); end }
			x.report("getpwuid") { n.times do execute_sql(@nss["getpwuid"].gsub('%1$u', @user_ids.sample.to_s)); end }
			x.report("getspnam") { n.times do execute_sql(@nss["getspnam"].gsub("%1$s", @user_names.sample)); end }
			x.report("getpwent") { n.times do execute_sql(@nss["getpwent"]); end }
			x.report("getspent") { n.times do execute_sql(@nss["getspent"]); end }
			x.report("getgrnam") { n.times do execute_sql(@nss["getgrnam"].gsub('%1$s', @group_names.sample)); end }
			x.report("getgrgid") { n.times do execute_sql(@nss["getgrgid"].gsub("%1$u", @group_ids.sample.to_s)); end }
			x.report("getgrent") { n.times do execute_sql(@nss["getgrent"]); end }

			x.report("memsbygid") { n.times do execute_sql(@nss["memsbygid"].gsub("%1$u", @group_ids.sample.to_s)); end }
			x.report("gidsbymem") { n.times do execute_sql(@nss["gidsbymem"].gsub('%1$s', @user_names.sample)); end }
		end
	end
end

x = LibnssMysqlTest.new
x.setup
x.run

