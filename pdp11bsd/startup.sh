#!/bin/bash

cd /machines
if [ -f RA81.000 ]; then
	exec pdp11
else
	if [ -f RA81.000.gz ]; then
		gunzip RA81.000.gz
		exec pdp11
	else
		echo "Compressed image file (RA81.000.gz) missing!"
		exec bash
	fi
fi
