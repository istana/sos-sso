require 'dotenv/load'
# config valid for current version and patch releases of Capistrano
lock "~> 3.11"

set :application, "#{ENV["APP_NAME"]}_#{fetch(:stage)}"
set :repo_url, "~/_uploaded"

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all

append :linked_dirs, '.bundle'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'
append :linked_dirs, 'content', 'public/images'
append :linked_files, 'config/database.yml', 'config/secrets.yml'

set :keep_releases, 10

# Uncomment the following to require manually verifying the host key before first deploy.
#set :ssh_options, verify_host_key: :always

set :passenger_restart_with_touch, true
