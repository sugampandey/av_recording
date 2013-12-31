set :application, "avrecorder"
set :repository,  "git@github.com:sugampandey/av_recording.git"
set :branch, fetch(:branch, "master")
set :scm, :git
server '50.197.140.116', :app, :web, :db, :primary => true
require 'bundler/capistrano'
set :rails_env, 'production'
set :deploy_to, "/home/sugam/Projects/#{application}"
set :user, "sugam"
set :use_sudo, false
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :deploy_via, :remote_cache
set :rake, 'bundle exec rake'
set :keep_releases, 3
after "deploy:restart", "deploy:cleanup"
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end