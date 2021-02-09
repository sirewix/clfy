#!/bin/sh

# import(options)
# import(backends/`CLF_BACKEND'.sh)
# import(status.sh)

stop () {
  is_it_running && really_stop
}

really_stop () {
  tracker_stop
  $notifier "Stop tracking" ""
  total_time_per_day=$(tracker_get_today_total_time)
  start_time=""
  description=""
  write_status
}

start () {
  stop
  tracker_start "$1"
  $notifier "Start tracking" "$1"
  start_time=$(date +%s)
  description="$1"
  write_status
  old_hist="${hist_file}-old"
  cp -f "$hist_file" "$old_hist"
  (echo "$1"; cat "$old_hist") | comb > "$hist_file"
}

sync () {
  n=${1-3}
  tracker_get_entries_last_n_days $n | comb > "$hist_file"
  $notifier "Tracker history for the last ${n} days synchronized"
}

print_usage () {
  progname=$(basename "$0")
  cat <<EOL
m4_include(usage)
EOL
}

start_dmenu () {
  input="$(cat "$hist_file" | $selector "Start tracking")"
  [ -z "$input" ] || (read_status && start "$input")
}

case $1 in
  sync) sync $2 ;;
  start) read_status && start "$2" ;;
  stop) read_status && stop ;;
  start-dmenu) start_dmenu ;;
  status) read_status && format_status ;;
  help) print_usage ;;
  *) print_usage ;;
esac
