# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

## add test/external_configs into tests
require 'rake/testtask'

namespace :test do
	desc "Test external configs"
	Rake::TestTask.new(:external_configs) do |t|
		t.libs << "test"
		t.pattern = 'test/external_configs/**/*_test.rb'
		t.verbose = true
	end

	desc "Test things from lib directory"
	Rake::TestTask.new(:libdir) do |t|
		t.libs << "test"
		t.pattern = 'test/lib/**/*_test.rb'
		t.verbose = true
	end
end

lib_task = Rake::Task["test:libdir"]
configs_task = Rake::Task["test:external_configs"]
test_task = Rake::Task[:test]
test_task.enhance { lib_task.invoke }
test_task.enhance { configs_task.invoke }

