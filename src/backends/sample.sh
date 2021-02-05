# import(options)

tracker_start () {
  # start tracking
  # takes entry as an argument
}

tracker_stop () {
  # stop tracking
}

tracker_format_description () {
  # format time entry description for a bar (e.g. polybar)
  # takes description
  # prints result
}

tracker_get_entries_last_n_days () {
  # used to substitute local history with remote one
  # takes number of days
  # prints one line for each time entry
}

tracker_get_today_total_time () {
  # get total time for today
}
