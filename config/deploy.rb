require 'palmtree/recipes/mongrel_cluster'

set :application, "snotes"

set :deploy_via, :copy
#set :copy_cache, true
set :repository, "file://."


set :deploy_to, "/home/mongrel/railsapps/#{application}"

set :scm, :git

set :user, 'mongrel'

role :app, "rubymatters.de"
role :web, "rubymatters.de"
role :db,  "rubymatters.de", :primary => true

set :use_sudo, false

set :mongrel_conf, "#{shared_path}/config/mongrel_cluster.yml"
set :mongrel_user, 'mongrel'
set :mongrel_group, 'mongrel'

set :mongrel_port, '9000'
set :mongrel_servers, '2'
set :mongrel_address, '127.0.0.1'
set :mongrel_environment, 'production'

set :mongrel_pid, "#{shared_path}/log/mongrel_cluster.#{application}.pid"


after 'deploy:setup', :setup_mongrel_conf
after 'deploy:update_code', :set_symlinks

desc "setting up mongrel"
task :setup_mongrel_conf do
  mongrel_configuration = <<EOF
---
port: 11000
pid_file: #{mongrel_pid}
servers: #{mongrel_servers}
address: #{mongrel_address}
cwd: #{deploy_to}/current
environment: #{mongrel_environment}
EOF

  run "mkdir -p #{shared_path}/config"
  put mongrel_configuration, mongrel_conf

end



desc "setting additional symlinks"
task :set_symlinks do
  run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "cp #{shared_path}/config/twitter.yml #{release_path}/config/twitter.yml"
end