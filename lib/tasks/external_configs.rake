require 'external_configs'

namespace :external_configs do
	desc 'set mysql user and password, from database.yml'
	task :setsql => :environment do
		@files = YAML.load_file(File.join(Rails.root, 'config'))

		# postfix
		#File.read()


	end
end
