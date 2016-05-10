#!/bin/sh

cd /machines
if [ -f RA81.000 ]; then
	echo "Found uncompressed OS image file, starting simulator."
	exec vax780
else
	if [ -f RA81.000.gz ]; then
		echo "Uncompressing OS image file..."
		gunzip RA81.000.gz
		echo "OS image file uncompressed, starting simulator."
		exec vax780
	else
		echo "Compressed image file (RA81.000.gz) missing!"
		exec bash
	fi
fi
