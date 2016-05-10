#!/bin/sh

if [ "$1" != "" ]; then
	exec "$1"
else
   exec busybox sh
fi
