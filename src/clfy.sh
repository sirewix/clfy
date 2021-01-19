#!/bin/sh

# import(options)
# import(backends/`CLF_BACKEND'.sh)

format_status () {
  read -r start_time
  read -r yoba
  now=$(date +%s)
  diff=$((now - start_time))
  desc=$(tracker_format_description $1)

  date -u -d "@${diff}" +"${desc} – %H:%M"
}

start () {
  [[ -f "$status_file" ]] && tracker_stop
  tracker_start "$1"
  $notifier "Start tracking" "$1"
  (date +%s; echo "$1") > "$status_file"
  old_hist="${hist_file}-old"
  cp -f "$hist_file" "$old_hist"
  (echo "$1"; cat "$old_hist") | comb > "$hist_file"
}

stop () {
  tracker_stop
  $notifier "Stop tracking" ""
  rm "$status_file"
}

status () {
  if [ -f "$status_file" ]; then
    cat "$status_file" | format_status
  else
    echo ""
  fi
}

sync () {
  n=${1-3}
  tracker_get_entries_last_n_days $n | comb > "$hist_file"
  $notifier "Tracker history for the last $n days synchronized"
}

print_usage () {
  progname=$(basename "$0")
  cat <<EOL
m4_include(usage)
EOL
}

start_dmenu () {
  input="$(cat "$hist_file" | $selector "Start tracking")"
  [[ -z "$input" ]] || start "$input"
}

case $1 in
  sync) sync $2 ;;
  start) start "$2" ;;
  stop) stop ;;
  start-dmenu) start_dmenu ;;
  status) status ;;
  help) print_usage ;;
  *) print_usage ;;
esac
