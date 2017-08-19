#!/bin/bash

# Warning & Usage
usage() { echo -e "Usage: $0 \n-c <Critical Threshold %> \n-w <Warning Threshold %> \n-e <Valid Email Address to Send the Report>" 1>&2; exit; }
warn() { echo -e "Usage: $0 \nCritical Threshold must be greater than Warning Threshold" 1>&2; exit; }

# Arguments
while getopts ":c:w:e:" o; do
	case "${o}" in
	 c)
		c=${OPTARG}
		;;
	 w)
		w=${OPTARG}
		;;
	 e)
		e=${OPTARG}
		;;
	 *)
	   usage
	   exit
	   ;;
	esac
done

# Error Checking
# Null check
if [ -z "${c}" ] || [ -z "${w}" ] || [ -z "${e}" ]; then
    usage
fi
# Critical > Warning
if (( $(echo "${w} > ${c}" |bc -l ) )); then
	warn
fi

# Main
free
TOTAL_MEMORY=$( free | grep Mem: | awk '{ print $2 }' )
echo $TOTAL_MEMORY

# Check
if (( $(echo "$TOTAL_MEMORY >=  ${c}" |bc -l ) )); then
	now=$(date +"%Y%m%d %H:%M")
	top -m | head -n 10 | mail -s "$now memory check - critical" ${e}
	exit 2
elif (( $(echo "$TOTAL_MEMORY >= ${w} && $TOTAL_MEMORY < ${c}" |bc -l ) )); then
	exit 1
elif (( $(echo "$TOTAL_MEMORY <  ${w}" |bc -l ) )); then
	exit 0
fi
