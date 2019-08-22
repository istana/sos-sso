source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# https://github.com/jeremyevans/ruby-string-crypt/pull/1
# works in <=2.6, but will be deprecated at any time
ruby '>= 2.5', '< 2.7' if RUBY_ENGINE == 'ruby'
#gem 'string-crypt'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'
# Use Uglifier as compressor for JavaScript assets

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'mysql2'
gem 'rails_admin'
# authentication
gem 'devise'
# history
gem 'paper_trail'
gem 'paper_trail-association_tracking'
# Samba password
gem 'smbhash'
# run programs in CommandLine
gem 'terrapin'
gem 'kaminari-i18n'
gem 'rails-i18n'

group :development, :test do
  gem 'rails-perftest'
  gem 'ruby-prof'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'm'
  gem 'pry'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # mocks and stubs
  gem 'mocha'
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
