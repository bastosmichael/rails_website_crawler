require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina_sidekiq/tasks'
# require 'mina/puma'

set :user, 'ubuntu'
set :domain, ENV['DOMAIN']
set :deploy_to, '/home/ubuntu/skynet'
set :app_path, lambda { "#{deploy_to}/#{current_path}" }
set :repository, 'git@github.com:bastosmichael/skynet.git'
set :branch, 'master'
set :forward_agent, true
set :rails_env, 'production'

set :shared_paths, ['config/sidekiq.yml',
                    'config/config.yml',
                    'app/sites',
                    'tmp/sockets',
                    'tmp/pids',
                    'log']

task :environment do
  invoke :'rvm:use[ruby-2.2.2]'
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_parnth}/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/sidekiq.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/config.yml"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/app/sites"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/app/sites"]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'deploy:cleanup'

    to :launch do
      # invoke :"sidekiq:restart"
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      # queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      invoke :'puma:restart'
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

namespace :puma do
  desc "Start the application"
  task :start do
    queue 'echo "-----> Start Puma"'
    queue "cd #{app_path} && RAILS_ENV=#{rails_env} && bin/puma.sh start", :pty => false
  end

  desc "Stop the application"
  task :stop do
    queue 'echo "-----> Stop Puma"'
    queue "cd #{app_path} && RAILS_ENV=#{rails_env} && bin/puma.sh stop"
  end

  desc "Restart the application"
  task :restart do
    queue 'echo "-----> Restart Puma"'
    queue "cd #{app_path} && RAILS_ENV=#{rails_env} && bin/puma.sh restart"
  end
end
