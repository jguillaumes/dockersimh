#!/bin/sh

OSIMAGE=RA90VHD.000
SIMULATOR=vax
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
		echo "Compressed image file (RA81.000.gz) missing!"
		exec $CONTSHELL
	fi
fi
