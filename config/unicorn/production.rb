# paths
app_path = '/home/ubuntu/social-api'
working_directory "#{app_path}/current"
pid "#{app_path}/current/tmp/pids/unicorn.pid"

# listen
listen "#{app_path}/current/tmp/sockets/unicorn.sock", backlog: 1024

user 'ubuntu'

# logging
stderr_path 'log/unicorn.stderr.log'
stdout_path 'log/unicorn.stdout.log'

# workers
worker_processes 2

# use correct Gemfile on restarts
before_exec do |_server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end

# preload
preload_app true

before_fork do |server, _worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |_server, _worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
