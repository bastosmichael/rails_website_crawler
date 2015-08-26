#! /bin/sh

PUMA_CONFIG_FILE=/home/ubuntu/skynet/current/config/puma.rb
PUMA_PID_FILE=/home/ubuntu/skynet/shared/tmp/pids/puma.pid
PUMA_SOCKET=/home/ubuntu/skynet/shared/tmp/sockets/puma.sock

# check if puma process is running
puma_is_running() {
  if [ -S $PUMA_SOCKET ] ; then
    if [ -e $PUMA_PID_FILE ] ; then
      if cat $PUMA_PID_FILE | xargs pgrep -P > /dev/null ; then
        return 0
      else
        echo "No puma process found"
      fi
    else
      echo "No puma pid file found"
    fi
  else
    echo "No puma socket found"
  fi

  return 1
}

case "$1" in
  start)
    echo "Starting puma..."
      rm -f $PUMA_SOCKET
      if [ -e $PUMA_CONFIG_FILE ] ; then
        bundle exec puma -C $PUMA_CONFIG_FILE
      else
        bundle exec puma
      fi

    echo "done"
    ;;

  stop)
    echo "Stopping puma..."
      kill -s SIGTERM `cat $PUMA_PID_FILE`
      rm -f $PUMA_PID_FILE
      rm -f $PUMA_SOCKET

    echo "done"
    ;;

  restart)
    if puma_is_running ; then
      echo "Hot-restarting puma..."
      kill -s SIGUSR2 `cat $PUMA_PID_FILE`

      echo "Doublechecking the process restart..."
      sleep 5
      if puma_is_running ; then
        echo "done"
        exit 0
      else
        echo "Puma restart failed :/"
      fi
    fi

    echo "Trying cold reboot"
    bin/puma.sh start
    ;;

  *)
    echo "Usage: script/puma.sh {start|stop|restart}" >&2
    ;;
esac
