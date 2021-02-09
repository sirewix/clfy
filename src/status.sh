default_status () { echo ; echo ; echo ; date -I ; }

format_status () {
  now=$(date +%s)
  if ! [ -z "$start_time" ]; then
    diff=$((now - start_time))
    current_task_duration=$(date -u -d "@${diff}" +'%H:%M')
    desc=$(tracker_format_description "$description")
    current_task="${desc} – ${current_task_duration}"
  else
    current_task=""
  fi

  if ! ([ -z "$total_time_per_day" ] || [ -z "$current_task" ]) ; then
    echo "${current_task} + ${total_time_per_day}"
  elif ! [ -z "$total_time_per_day" ] ; then
    echo "$total_time_per_day"
  elif ! [ -z "$current_task" ] ; then
    echo "$current_task"
  else
    echo ""
  fi
}

read_status () {
  if [ -f "$status_file" ] ; then
    read_and_update_status < "$status_file"
  else
    default_status > "$status_file"
    default_status | read_and_update_status
  fi
}

read_status_to_variables () {
  read -r total_time_per_day
  read -r start_time
  read -r description
  read -r last_update
}

read_and_update_status () {
  read_status_to_variables
  today=$(date -I)
  if ! [ "$today" = "$last_update" ]; then
    total_time_per_day=$(tracker_get_today_total_time)
    last_update="$today"
    write_status
  fi
}

write_status () { print_status > "$status_file" ; }

print_status () {
  echo "$total_time_per_day"
  echo "$start_time"
  echo "$description"
  echo "$last_update"
}

is_it_running () { ! [ -z "$start_time" ] ; }
