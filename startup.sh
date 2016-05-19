#!/bin/sh
LD_LIBRARY_PATH=/usr/lib:/usr/local/lib:$LD_LIBRARY_PAHT
export LD_LIBRARY_PATH

if [ "$1" != "" ]; then
	exec "$1"
else
   exec busybox sh
fi
