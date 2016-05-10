#!/bin/sh

cd /machines
if [ -f RA81.000 ]; then
    echo "Found uncompressed OS image file, starting simulator."
    exec pdp11
else
	if [ -f RA81.000.gz ]; then
		echo "Uncompressing OS image file..."
		gunzip RA81.000.gz
		exec pdp11
		echo "OS image file uncompressed, starting simulator."	
	else
		echo "Compressed image file (RA81.000.gz) missing!"
		exec busybox sh
	fi
fi
