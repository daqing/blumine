ssh_options[:username] = 'ubuntu'
ssh_options[:keys] = [File.join(ENV['HOME'], '.ec2', 'gsg-keypair.pem')]

set :application, "blumine"
set :repository,  "git://github.com/daqing/blumine.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "blumine.forkgeek.com"
role :app, "blumine.forkgeek.com"                          # This may be the same as your `Web` server
role :db,  "blumine.forkgeek.com", :primary => true # This is where Rails migrations will run
role :db,  "blumine.forkgeek.com"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

desc "Echo the server's hostname"
task :echo, :roles => :web do
  run "echo `hostname`"
end

namespace :blumine do
  desc "update code from git repo"
  after :update_code, :restart_thin, :restart_nginx
  task :update_code do
    run "cd ~/repo/blumine && git pull"
  end

  desc "restart thin"
  task :restart_thin do
    run "sudo /etc/init.d/thin restart"
  end

  desc "restart nginx"
  task :restart_nginx do
    run "sudo /usr/local/nginx/sbin/nginx -s reload"
  end
end

after "blumine:update_code", "blumine:restart_thin", "blumine:restart_nginx"


