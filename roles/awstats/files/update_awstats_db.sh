#!/usr/bin/env bash
#
# Script to update awstats analytics db
# Author: Rohit Gupta - @rohit01
#

working_directory="$1"
site_domain="$2"
ulimit -n 1000000

# Maximum parallel execution
max_workers=20

find "${working_directory}" -name "*.log" -mmin -185 | while read f
do
    jobs_count="$(jobs -p | wc -l)"
    while [ ${jobs_count} -gt ${max_workers} ]; do
        sleep 1
        jobs_count="$(jobs -p | wc -l)"
    done
    nice -n 20 /usr/local/awstats/wwwroot/cgi-bin/awstats.pl -update -config="${site_domain}" -LogFile="$f" &
done
