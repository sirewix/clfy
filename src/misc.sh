comb () {
  awk '!visited[$0]++'
}

to_args () {
  while read -r line; do
    $1 $line
  done
}

sum_dates () {
  sum=0
  epoch='jan 1 1970'
  while read dur; do
    dur_secs=$(date -u -d "$epoch $dur" +%s)
    sum=$(($sum + $dur_secs))
  done
  date -u -d "@${sum}" +'%H:%M'
}
