set :user, 'mongrel'

# set :rails_env, 'production'

set :deploy_to, "/home/mongrel/railsapps/#{application}"

role :app, "78.46.102.66"
role :web, "78.46.102.66"
role :db,  "78.46.102.66", :primary => true
