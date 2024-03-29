source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
gem 'mysql2'
gem 'rails_admin', '~> 3.1'
# authentication
gem 'devise'
# https://stackoverflow.com/questions/66914608/undefined-method-scope-for-papertrailversionconcernmodule-nomethoderror
gem 'paper_trail', '~> 14.0'
gem 'paper_trail-association_tracking'
# Samba password
gem 'smbhash'
# run programs in CommandLine
gem 'terrapin'
gem 'kaminari-i18n'
gem 'rails-i18n'
gem 'rails_admin-i18n'
gem 'devise-i18n'
gem 'devise-i18n-views'
gem 'dotenv-rails'

group :development, :test do
  gem 'rails-perftest', github: 'rails/rails-perftest'
  gem 'ruby-prof'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'm'
  gem 'pry'
end

group :development do
  # Use Puma as the app server
  gem 'puma'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5'
  # fake data generator
  gem 'ffaker'
  # test suite
  gem 'minitest'
  gem 'minitest-rails'
  # output formatter
  gem 'minitest-reporters'
  gem 'database_cleaner'
  gem 'capistrano', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rbenv', require: false
  gem 'cape', require: false
  # noecho password to the ssh key
  gem 'highline', require: false
  gem 'annotate', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'sassc-rails'
