# import(options)
# import(misc.sh)

get_entries_by_date () {
  clockify-cli log --format "{{.Description}}${clockify_proj_delim}{{.Project.Name}}" --date $1
}

get_projects () {
  clockify-cli project list --format '{{.ID}} {{.Name}}'
}

generate_date_span () {
  for i in $(seq $1 $2); do
    date -I -d "$(date -I) -$i days"
  done
}

tracker_start () {
  biba=$(echo "$1" | sed "s/${clockify_proj_delim}/@/")
  IFS='@' read -a arr <<< "$biba"
  description="${arr[0]}"
  project_name="${arr[1]}"
  echo "$description :: $project_name"
  project_id=$(grep "^[a-f0-9]\\+ ${project_name}\$" "$projects_file" | cut -f1 -d' ')
  [[ -z $project_id ]] && $notifier "Unknown clockify project" && exit 1
  clockify-cli start "$project_id" "$description"
}

tracker_stop () {
  clockify-cli out
}

tracker_format_description () {
  biba=$(echo "$yoba" | sed "s/${clockify_proj_delim}/@/")
  IFS='@' read -a arr <<< "$biba"
  echo "${arr[0]}"
}

tracker_get_entries_last_n_days () {
  get_projects > "$projects_file"
  generate_date_span 0 $1 | to_args get_entries_by_date
}
