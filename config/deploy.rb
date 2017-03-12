require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/chruby'
require 'mina_sidekiq/tasks'
require 'mina/unicorn'
require 'progress'

set :user, 'ubuntu'
set :domain, ENV['DOMAIN']
set :domains, File.read('production').split
set :deploy_to, '/home/ubuntu/skynet'
set :app_path, lambda { "#{fetch(:deploy_to)}/#{current_path}" }
set :repository, 'https://github.com/bastosmichael/skynet.git'
set :branch, 'master'
set :forward_agent, true
set :rails_env, 'production'
set :keep_releases, 5
set :sidekiq_log, "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/log/sidekiq.log"
set :sidekiq_pid, "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp/pids/sidekiq.pid"

set :shared_dirs, fetch(:shared_dirs, []).push( 'public/static',
                                                'public/sitemaps',
                                                'app/sites',
                                                'tmp/sockets',
                                                'tmp/pids',
                                                'log' )


set :shared_files, fetch(:shared_files, []).push( 'config/sidekiq.yml',
                                                  'config/config.yml',
                                                  'config/secrets.yml' )

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
    # command %{cd "#{fetch(:shared_path)}/app/sites" && git pull origin master}
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'
    invoke :'unicorn:restart'
    # invoke :'sidekiq:restart'

    on :launch do
      # queue "touch #{fetch(:deploy_to)}/#{fetch(:shared_path)}/pids/sidekiq.pid"
      # invoke :'sidekiq:restart'
      # queue "mkdir -p #{fetch(:deploy_to)}/#{current_path}/tmp/"
      # invoke :'unicorn:restart'
      # queue "touch #{fetch(:deploy_to)}/#{current_path}/tmp/restart.txt"
    end
  end
end

desc "Update sites folder"
task :update_all => :environment do
  fetch(:domains).with_progress.each do |domain|
    set :domain, domain
    command %{cd "#{fetch(:shared_path)}/app/sites" && git pull origin master}
  end
end

# ssh ubuntu@0.0.0.0 'cd skynet/shared/app/sites/; git pull origin master'

desc "Sidekiq Restart all servers"
task :sidekiq_all => :environment do
  fetch(:domains).with_progress.each do |domain|
    set :domain, domain
    # invoke :chruby, 'ruby-2.3.0'
    command %{cd "#{fetch(:deploy_to)}/current" && RAILS_ENV=production bundle exec sidekiq -d -L log/sidekiq.log -c 1}
    # invoke :'sidekiq:restart'
  end
end

desc "Unicorn Restart all servers"
task :unicorn_all => :environment do
  fetch(:domains).with_progress.each do |domain|
    set :domain, domain
    invoke :'unicorn:restart'
  end
end

desc "Unlock all servers"
task :unlock_all => :environment do
  fetch(:domains).with_progress.each do |domain|
    set :domain, domain
    invoke :'deploy:force_unlock'
  end
end

desc "Deploy to all servers"
task :deploy_all => :environment do
  fetch(:domains).with_progress.each do |domain|
    set :domain, domain
    invoke :deploy
  end
end

# require 'mina/rails'
# require 'mina/git'
# # require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# # require 'mina/rvm'    # for rvm support. (https://rvm.io)

# # Basic settings:
# #   domain       - The hostname to SSH to.
# #   deploy_to    - Path to deploy into.
# #   repository   - Git repo to clone from. (needed by mina/git)
# #   branch       - Branch name to deploy. (needed by mina/git)

# set :application_name, 'foobar'
# set :domain, 'foobar.com'
# set :deploy_to, '/var/www/foobar.com'
# set :repository, 'git://...'
# set :branch, 'master'

# # Optional settings:
# #   set :user, 'foobar'          # Username in the server to SSH to.
# #   set :port, '30000'           # SSH port number.
# #   set :forward_agent, true     # SSH forward_agent.

# # shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# # set :shared_dirs, fetch(:shared_dirs, []).push('somedir')
# # set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

# # This task is the environment that is loaded for all remote run commands, such as
# # `mina deploy` or `mina rake`.
# task :environment do
#   # If you're using rbenv, use this to load the rbenv environment.
#   # Be sure to commit your .ruby-version or .rbenv-version to your repository.
#   # invoke :'rbenv:load'

#   # For those using RVM, use this to load an RVM version@gemset.
#   # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
# end

# # Put any custom commands you need to run at setup
# # All paths in `shared_dirs` and `shared_paths` will be created on their own.
# task :setup do
#   # command %{rbenv install 2.3.0}
# end

# desc "Deploys the current version to the server."
# task :deploy do
#   # uncomment this line to make sure you pushed your local branch to the remote origin
#   # invoke :'git:ensure_pushed'
#   deploy do
#     # Put things that will set up an empty directory into a fully set-up
#     # instance of your project.
#     invoke :'git:clone'
#     invoke :'deploy:link_shared_paths'
#     invoke :'bundle:install'
#     invoke :'rails:db_migrate'
#     invoke :'rails:assets_precompile'
#     invoke :'deploy:cleanup'

#     on :launch do
#       in_path(fetch(:current_path)) do
#         command %{mkdir -p tmp/}
#         command %{touch tmp/restart.txt}
#       end
#     end
#   end

#   # you can use `run :local` to run tasks on local machine before of after the deploy scripts
#   # run(:local){ say 'done' }
# end
# # For help in making your deploy script, see the Mina documentation:
# #
# #  - https://github.com/mina-deploy/mina/tree/master/docs
