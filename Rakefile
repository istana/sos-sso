# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# remove fucking shitty test task
Rake::Task["default"].clear
## add additional directories like test/external_configs into tests
require 'rake/testtask'

namespace :test do
  desc 'run all test'
  Rake::TestTask.new(:all) do |t|
    t.libs << "test"
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
  end
end

task :default do
  Rake::Task["zeitwerk:check"].invoke
  Rake::Task["test:all"].invoke
end

