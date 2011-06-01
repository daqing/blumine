ssh_options[:username] = 'ubuntu'
ssh_options[:keys] = [File.join(ENV['HOME'], '.ec2', 'gsg-keypair.pem')]

# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# # Load RVM's capistrano plugin.    
require "rvm"
require "rvm/capistrano"

# set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user  # Don't use system-wide RVM

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

def get_branch
  ENV['branch'] || ENV['br']
end

namespace :blumine do
  desc "deploy blumine"
  task :deploy do
    puts '** Pushing code to GitHub...'
    `git push origin #{get_branch}`
  end

  desc "update code from git repo"
  task :update_code do
    run "cd ~/repo/blumine && git checkout #{get_branch} && git pull origin #{get_branch}:#{get_branch}"
  end

  desc "install gems"
  task :install_gems do
    run "cd ~/repo/blumine && RAILS_ENV=production bundle install"
  end

  desc "run migrations in production environment"
  task :db_migrate do
    run "cd ~/repo/blumine && rake RAILS_ENV=production db:migrate"
  end

  desc "restart thin"
  task :restart_thin do
    run "sudo /etc/init.d/thin restart"
  end

  desc "restart nginx"
  task :restart_nginx do
    run "sudo /usr/local/nginx/sbin/nginx -s reload"
  end

  desc "tail production logs"
  task :rails_logs do
    run "tail ~/repo/blumine/log/production.log"
  end

  desc "tail nginx error logs"
  task :nginx_error_logs do
    run "tail /usr/local/nginx/logs/error.log"
  end

  desc "tail thin logs"
  task :thin_logs do
    run <<-CMD
      cd ~/repo/blumine/log/ &&
      for log in `ls thin.*.log`; do echo $log && tail $log; done
    CMD
  end

  desc "count all users"
  task :count_all do
    run <<-CMD
      cd ~/repo/blumine/log/ &&
      RAILS_ENV=production rails runner "puts User.count"
    CMD
  end

  desc "count today's users"
  task :count_todays do
    run <<-CMD
      cd ~/repo/blumine/log/ &&
      RAILS_ENV=production rails runner "puts User.where(['created_at >= ?', Date.today]).size"
    CMD
  end

  desc "run a piece of code in production environment"
  task :runner do
    run <<-CMD
      cd ~/repo/blumine/log/ &&
      RAILS_ENV=production rails runner "#{ENV['cmd']}"
    CMD
  end

  desc "switch git branches"
  task :git_checkout do
    run <<-CMD
      cd ~/repo/blumine/ && git checkout #{get_branch}
    CMD
  end
end

after "blumine:deploy", "blumine:update_code", "blumine:install_gems", "blumine:db_migrate", "blumine:restart_thin"

