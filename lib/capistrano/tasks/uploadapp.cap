namespace :deploy do
  desc '+ Upload application via Rsync'
  task :upload do |t|
    require 'yaml'
    puts "Stage: #{fetch(:stage)}"
    c = YAML::load_file(File.expand_path("../../../../config/variables.yml", __FILE__))[fetch(:stage).to_s]
    FileUtils.rm_rf('_rsync_cache')
    FileUtils.mkdir('_rsync_cache')
    puts 'Configuration', c.inspect
    user = c['user']
    host = c['host']
    if !user || !host
      puts "User or host is missing in the configuration"
      exit
    end
    puts "User: #{user}", "Host: #{host}"
    `git clone --no-hardlinks --local . _rsync_cache`
    system("rsync --rsh='ssh' _rsync_cache/ #{user}@#{host}:_uploaded --verbose --recursive --delete --compress --progress")
  end  
end

# must be before, git copy is ran here
before 'deploy:check', 'deploy:upload'
