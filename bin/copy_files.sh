#!/bin/bash

## Resilient way to copy files, avoid Network file System glitch problems
##
function copy_files {
	echo " copy $1 $2"
	copy_files_rec "$1" "$2" "0"
}

function copy_files_rec {
	set +e
	let x=$3+1
	cp $1 $2
	if [[ "$?" == "0" ]]; then
		echo "copy done"
		return 0
	elif [[ $x -ge 10 ]]; then
		echo " too much try, cancel..."
		exit -1
	else
	    echo "copy failure, try again... $3"
            copy_files_rec "$1" "$2" "$x"
	fi
}

