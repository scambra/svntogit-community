#!/bin/bash

. /etc/rc.conf
. /etc/rc.d/functions

PID=`pidof -o %PPID /usr/sbin/uptimed`
case "$1" in
  start)
    stat_busy "Starting Uptimed Daemon"
    [ -z "$PID" ] && /usr/sbin/uptimed -b    # create the boot record
    if [ $? -gt 0 ] ; then
      stat_fail
    else
      add_daemon uptimed                     # create the 'state' dir
      /usr/sbin/uptimed                      # fire up the daemon
	if [ $? -gt 0 ]; then
	  stat_fail
	fi
      stat_done 
    fi
    ;;
  stop)
    stat_busy "Stopping Uptimed Daemon"
    [ "$PID" ] && kill $PID &> /dev/null
    if [ $? -gt 0 ]; then
      stat_fail
    else
      rm_daemon uptimed                      # remove the 'state' dir
      stat_done
    fi
    ;;
  restart)
    $0 stop
    $0 start
    ;;
  *)
    echo "usage: $0 {start|stop|restart}"
esac
exit 0
