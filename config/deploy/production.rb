# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, ENV['DOMAIN']

set :branch, ENV.fetch('BRANCH', 'master')

set :keep_releases, 5

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server ENV['DOMAIN'], user: 'ubuntu', roles: %w(app)

set :assets_roles, [:app]
#set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}

namespace :mojopages do
  namespace :deploy do
    task :finished do

    end
  end

  task :prepare_bundle_config do
    on roles(:app) do
      # execute 'chruby-exec ruby-2.2.1 -- bundle config build.pg --with-pg-config=/usr/pgsql-9.4/bin/pg_config'
    end
  end
end

# before 'bundler:install', 'mojopages:prepare_bundle_config'
# after 'deploy:finished', 'mojopages:deploy:finished'

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
