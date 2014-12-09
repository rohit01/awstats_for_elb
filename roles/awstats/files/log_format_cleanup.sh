#!/usr/bin/env bash
#
# Script to replace pattern "<ip>:<port>" with "<ip> <port>" in AWS ELB logs
# Author: Rohit Gupta - @rohit01
#

working_directory="$1"
ulimit -n 1000000

# Maximum parallel execution
max_workers=100

find "${working_directory}" -name "*.log" -mmin -185 | while read f
do
    jobs_count="$(jobs -p | wc -l)"
    while [ ${jobs_count} -gt ${max_workers} ]; do
        sleep 1
        jobs_count="$(jobs -p | wc -l)"
    done
    (
        last_modified="$(stat -c %y "$f")"
        nice -n 20 sed -i 's/\( [0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\)\:\([0-9][0-9]*\)/\1 \2/g' "$f"
        # Restore timestamp
        touch -d "${last_modified}" "$f"
    ) &
done
