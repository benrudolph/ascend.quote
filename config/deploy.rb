require 'bundler/capistrano'
require "capistrano-rbenv"
set :rbenv_ruby_version, "1.9.3-p392"

set :application, "quote-it"

load 'deploy/assets'

# Deploy from your local Git repo by cloning and uploading a tarball
set :scm, :git
set :repository,  "git@github.com:benrudolph/quote-it.git"
require '/Users/benrudolph/Dropbox/credientials/capcreds.rb'
set :deploy_via, :copy
set :branch, "master"
set :deploy_via, :remote_cache
set :rails_env,     "production"


set :user, :root
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
set :ssh_options, { :forward_agent => true }

role :web, "176.58.105.165"                          # Your HTTP server, Apache/etc
role :app, "176.58.105.165"                          # This may be the same as your `Web` server
role :db,  "176.58.105.165", :primary => true # This is where Rails migrations will run

set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
task :simlink_database, :roles => :app do
  run "ln -s ~/quote-it.yml /var/www/quote-it/current/config/database.yml"
end

task :run_migrations, :roles => :app do
  run "RAILS_ENV=production rake db:migrate"
  run "RAILS_ENV=development rake db:migrate"
end

after 'deploy', :run_migrations

