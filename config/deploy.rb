set :stages, %w(production)
require 'capistrano/ext/multistage'

server "209.20.72.67", :app, :web, :db, :primary => true

set :user, 'subba'
set :keep_releases, 3
set :repository,"git@github.com:subbarao/electiondata.git"
set :use_sudo, false
set :scm, :git
set :deploy_via, :copy

set(:application) { "dazanu" }
set (:deploy_to) { "/home/#{user}/apps/#{application}" }
set :copy_remote_dir, "/home/#{user}/tmp"

# source: http://tomcopeland.blogs.com/juniordeveloper/2008/05/mod_rails-and-c.html
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "invoke the db migration"
  task:migrate, :roles => :app do
    send(run_method, "cd #{current_path} && rake db:migrate RAILS_ENV=#{stage} ")
  end


end

after "deploy:update_code", "app:copy_config_files","app:hoptoad"
before "deploy:migrate",  "db:backup"

namespace :app do
  desc "copies the configuration frile from ~/shared/config/*.yml to ~/config"
  task :copy_config_files,:roles => :app do
    run "cp -fv #{deploy_to}/shared/config/database.yml #{release_path}/config"
    run "cp -fv #{deploy_to}/shared/config/hoptoad.rb #{release_path}/config/initializers"
  end

  desc "test hoptoad"
  task:hoptoad, :roles => :app do
    run  "cd #{current_path} && rake hoptoad:test RAILS_ENV=#{stage} ")
  end
end

namespace :lab do
  desc "Usage: cap production app:show -s command=Article.first "
  task  :run do
    remote_data = ''
    remote_command = "#{deploy_to}/current/script/runner -e #{stage} #{command}"
    run remote_command do |channel, stream, data|
      # remote_data << data
    end
    puts remote_data
  end
end

