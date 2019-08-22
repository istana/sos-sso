namespace :deploy do
  desc '+ Upload application via Rsync'
  task :upload_app do |t|
    FileUtils.rm_rf('_rsync_cache')
    FileUtils.mkdir('_rsync_cache')

    user = fetch(:deploy_user)
    host = fetch(:deploy_host)

    if !user || !host
      puts "User or host is missing in the configuration"
      exit(1)
    end

    `git clone --no-hardlinks --local . _rsync_cache`
    system("rsync --rsh='ssh' _rsync_cache/ #{user}@#{host}:_uploaded --verbose --recursive --delete --compress --progress")
  end
end

before 'deploy:starting', 'deploy:upload_app'
