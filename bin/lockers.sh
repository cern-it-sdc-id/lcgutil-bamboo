#!/bin/bash


function create_lock {
	local wait_time=0;
	while [ $wait_time -le $2 ]; do
	mkdir $1 &> /dev/null
	if [[ "$?" != "0" ]]; then
		let wait_time=$wait_time+1
		echo " already locked.. sleep .. n $wait_time"
		sleep 1
	else
		echo " lock acquired"
		return 0
	fi
	done
	exit 1
}

function delete_lock {
	rm -rf $1
}


# wriite lock
# args : file_lock_path function arg1 arg2 arg3
function write_lock {

  set +e 

  echo "try to lock $1"
  create_lock "$1" 900		
  echo "execute in locked $2"
  $2 ${@:3}
  echo "unlock $1"
  delete_lock "$1"


}

