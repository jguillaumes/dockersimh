#!/bin/bash

cd /machines
if [ -f RA81.000 ]; then
	exec vax780
else
	if [ -f RA81.000.gz ]; then
		gunzip RA81.000.gz
		exec vax780
	else
		echo "Compressed image file (RA81.000.gz) missing!"
		exec bash
	fi
fi
