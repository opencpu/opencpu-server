#!/bin/bash

#This script has a loop to kill all Apache2 orphan children.
#It sounds more evil than it is.

#Note: we could also do `pgrep -u www-data -P 1` but will not work recursively.

killtree() {
    local _pid=$1
    local _sig=${2-TERM}
    for _child in $(ps -o pid --no-headers --ppid ${_pid}); do
        killtree ${_child} ${_sig}
    done
    kill -${_sig} ${_pid}
}

while [ "true" ]
do
	ORPHANS=$(pgrep -u opencpu -P 1)
	for ORPHAN in $ORPHANS
	do
	  killtree $ORPHAN
	done
	sleep 2
done
