#!/bin/bash

## https://unix.stackexchange.com/questions/120570/how-can-i-monitor-cpu-usage-by-user

own=$(id -nu)

for user in $(who | awk '{print $1}' | sort -u)
do
    # print other user's CPU usage in parallel but skip own one because
    # spawning many processes will increase our CPU usage significantly
    if [ "$user" = "$own" ]; then continue; fi
    (top -b -n 1 -u "$user" | awk -v user="$user" 'NR>7 { sum += $9; } END { print user, sum; }') &
done
wait

# print own CPU usage after all spawned processes completed
top -b -n 1 -u "$own" | awk -v user=$own 'NR>7 { sum += $9; } END { print user, sum; }'
