set :application, 'snotes'

set :stages, %w(production)
set :default_stage, 'production'

require 'capistrano/ext/multistage'

# scm config
set :scm, :git
set :repository, 'git://github.com/alto/snotes.git'
set :branch, 'master'
set :deploy_via, :rsync_with_remote_cache

# system config
set :use_sudo, false

after 'deploy:update_code', :set_symlinks
after 'deploy', 'deploy:cleanup'

task :set_symlinks do
  run "ln -f -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -f -s #{shared_path}/config/twitter.yml #{release_path}/config/twitter.yml"
end

# Passenger specific restart
namespace :deploy do
  desc 'Restarting mod_rails with restart.txt'
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
