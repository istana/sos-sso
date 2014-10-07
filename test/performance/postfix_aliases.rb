require 'test_helper'
require 'rails/performance_test_help'
require 'external_configs'
require 'external_configs_benchmark_helper'

class PostfixAliasesTest
	include ExternalConfigsHelper

	def setup
		DatabaseCleaner.clean
		@nss = ExternalConfigs.read_libnss(File.join(Rails.root, "external_configs", "ipostfix-mysql-aliases.cf"))
		generate_nss_dataset(1000, 100)
	end

	def execute_sql(query)
		ActiveRecord::Base.connection.execute(query)
	end

	def run
		require 'benchmark'
		n = 50000
		Benchmark.bm(7) do |x|
			x.report("getpwnam") { n.times do execute_sql(@nss["getpwnam"].gsub('%1$s', @user_names.sample)); end }
			x.report("getpwuid") { n.times do execute_sql(@nss["getpwuid"].gsub('%1$u', @user_uids.sample.to_s)); end }
			x.report("getspnam") { n.times do execute_sql(@nss["getspnam"].gsub("%1$s", @user_names.sample)); end }
			x.report("getpwent") { n.times do execute_sql(@nss["getpwent"]); end }
			x.report("getspent") { n.times do execute_sql(@nss["getspent"]); end }
			x.report("getgrnam") { n.times do execute_sql(@nss["getgrnam"].gsub('%1$s', @group_names.sample)); end }
			x.report("getgrgid") { n.times do execute_sql(@nss["getgrgid"].gsub("%1$u", @group_gids.sample.to_s)); end }
			x.report("getgrent") { n.times do execute_sql(@nss["getgrent"]); end }

			x.report("memsbygid") { n.times do execute_sql(@nss["memsbygid"].gsub("%1$u", @group_gids.sample.to_s)); end }
			x.report("gidsbymem") { n.times do execute_sql(@nss["gidsbymem"].gsub('%1$s', @user_names.sample)); end }
		end
	end
end

x = PostfixAliasesTest.new
x.setup
x.run

