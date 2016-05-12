#!/bin/sh

OSIMAGE=RP04.000
SIMULATOR=pdp11
CONTSHELL="busybox sh"

cd /machines
if [ -f $OSIMAGE ]; then
	echo "Found uncompressed OS image file, starting simulator."
	exec $SIMULATOR
else
	if [ -f $OSIMAGE.gz ]; then
		echo "Uncompressing OS image file..."
		gunzip $OSIMAGE.gz
		echo "OS image file uncompressed, starting simulator."
		exec $SIMULATOR
	else
		echo "Compressed image file ($OSIMAGE.gz) missing!"
		exec $CONTSHELL
	fi
fi
