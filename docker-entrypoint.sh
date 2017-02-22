#!/usr/bin/env ash
set -o errexit
set -o pipefail
set -o nounset

main() {
  trap shutdown SIGINT SIGTERM SIGKILL
  trap reload SIGUSR1
  start
}

shutdown() {
  echo "Caught signal"
  echo "Shutdown server (pid=${PID})"

  kill ${PID}
  exit
}

start() {
  ./tsdnsserver &
  PID=$!
  echo "Start server (pid=${PID})"
  wait ${PID}
}

reload() {
  echo "Reload config"
  ./tsdnsserver --update
  wait ${PID}
}

PID=""
main

