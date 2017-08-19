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
if [ "${w}" -gt "${c}" ]; then
	warn
fi

# Test
echo "c = ${c}"
echo "w = ${w}"
echo "e = ${e}"

# Main
free
TOTAL_MEMORY=$( free | grep Mem: | awk '{ print $2 }' )
echo $TOTAL_MEMORY

# Check
if [ $TOTAL_MEMORY -ge  "${c}" ]; then
	echo "2"
	exit 2
elif [ $TOTAL_MEMORY -ge "${w}" && $TOTAL_MEMORY -lt "${c}" ]; then
	echo "1"
	exit 1
elif [ $TOTAL_MEMORY -lt  "${w}" ]; then
	echo "0"
	exit 0
fi


