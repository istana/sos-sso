source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

gem 'mysql2'

gem 'rails_admin', github: 'sferik/rails_admin'
## temporary
gem 'rack-pjax', github: 'afcapel/rack-pjax'
gem 'remotipart', github: 'mshibuya/remotipart'
# authentication
gem 'devise'#, github: 'plataformatec/devise'
# authorization
gem 'cancancan'
# history
gem 'paper_trail'

# Samba password
gem 'smbhash'
gem 'rails-i18n', '~> 5.0.0.beta4'
# run programs in CommandLine
gem 'cocaine'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rails-perftest', github: 'rails/rails-perftest'
  gem 'ruby-prof'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # run when something change
  #gem 'guard'
  #gem 'guard-livereload'
  #/home/tex/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/activesupport-5.0.0/lib/active_support/dependencies.rb:293: warning: loading in progress, circular require considered harmful - /home/tex/.rbenv/versions/2.3.1/lib/ruby/gems/2.3.0/gems/guard-minitest-2.4.5/lib/guard/minitest.rb
  #gem 'guard-minitest'

  # mocks and stubs
  gem 'mocha'

  # fake data generator
  gem 'ffaker', '~> 2.0'

  # test suite
  gem 'minitest'
  gem 'minitest-rails'#, github: 'blowmage/minitest-rails', branch: 'rails5'
  
  # output formatter
  gem 'minitest-reporters'
  
  # integration testing
  gem 'capybara'
  gem 'minitest-rails-capybara'#, github: 'blowmage/minitest-rails-capybara', branch: 'rails5'
  gem 'poltergeist'
  gem 'connection_pool'
  gem 'database_cleaner'
  
  gem 'capistrano', '~> 3.4.0', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-rails', '~> 1.1.3', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rbenv', '~> 2.0.3', require: false
  gem 'cape', require: false
  # noecho password to the ssh key
  gem 'highline', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
