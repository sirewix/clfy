comb () {
  awk '!visited[$0]++'
}

to_args () {
  while read -r line; do
    $1 $line
  done
}
