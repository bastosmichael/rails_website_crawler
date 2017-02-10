require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/chruby'
require 'mina_sidekiq/tasks'
require 'mina/unicorn'

set :user, 'ubuntu'
set :domain, ENV['DOMAIN']
set :deploy_to, '/home/ubuntu/skynet'
set :app_path, lambda { "#{fetch(:deploy_to)}/#{current_path}" }
set :repository, 'https://github.com/bastosmichael/skynet.git'
set :branch, 'master'
set :forward_agent, true
set :rails_env, 'production'
set :keep_releases, 5
set :sidekiq_log, "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/log/sidekiq.log"
set :sidekiq_pid, "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp/pids/sidekiq.pid"

set :shared_paths, ['public/static',
                    'public/sitemaps',
                    'config/sidekiq.yml',
                    'config/config.yml',
                    'config/secrets.yml',
                    'app/sites',
                    'tmp/sockets',
                    'tmp/pids',
                    'log']

task :environment do
  invoke :chruby, 'ruby-2.3.0'
end

task :setup => :environment do
  command %{mkdir -p "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/public"}
  command %{mkdir -p "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/public/static"}
  command %{mkdir -p "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/log"}
  command %{mkdir -p "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/config"}
  command %{mkdir -p "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp"}
  command %{mkdir -p "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp/sockets"}
  command %{mkdir -p "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp/pids"}
  command %{mkdir -p "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/app/sites"}

  command %{touch "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/config/sidekiq.yml"}
  command %{touch "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/config/config.yml"}
  command %{touch "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/config/secrets.yml"}

  command %{chmod g+rx,u+rwx "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/public"}
  command %{chmod g+rx,u+rwx "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/public/static"}
  command %{chmod g+rx,u+rwx "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/log"}
  command %{chmod g+rx,u+rwx "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/config"}
  command %{chmod g+rx,u+rwx "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp"}
  command %{chmod g+rx,u+rwx "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp/sockets"}
  command %{chmod g+rx,u+rwx "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp/pids"}
  command %{chmod g+rx,u+rwx "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/app/sites"}
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  on :before_hook do
    # Put things to run locally before ssh
  end

  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'sidekiq:quiet'
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      # queue "touch #{fetch(:deploy_to)}/#{fetch(:shared_path)}/pids/sidekiq.pid"
      # invoke :'sidekiq:restart'
      # queue "mkdir -p #{fetch(:deploy_to)}/#{current_path}/tmp/"
      # invoke :'unicorn:restart'
      # queue "touch #{fetch(:deploy_to)}/#{current_path}/tmp/restart.txt"
    end
  end
end
