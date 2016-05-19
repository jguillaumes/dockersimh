#!/bin/sh

OSIMAGE=RAUSER.000
SIMULATOR=vax8600
CONTSHELL="busybox sh"

cd /machines

if [ -f $OSIMAGE ]; then
	echo "Found uncompressed OS image file, starting simulator."
	exec $SIMULATOR
else
    if [ -f original-content ]; then
	if [ "$SIMH_USE_CONTAINER" == "yes" ]; then
	    echo "SIMH_USE_CONTAINER=$SIMH_USE_CONTAINER, using container storage"
	    echo "Copying distribution files..."
	    cp -v /image/* .
	    if [ -f $OSIMAGE.gz ]; then
		echo "Uncompressing OS image file..."
		gunzip $OSIMAGE.gz
		echo "OS image file uncompressed, starting simulator."
		exec $SIMULATOR
	    else
		echo "Compressed image file (${OSIMAGE}.gz) missing!"
		exec $CONTSHELL
	    fi
	else
	    echo "================================================================"
	    echo "= You have not mounted any external volume under /machines     ="
	    echo "= That means docker will create a volume to use as storage for ="
	    echo "= this container. The content of that volume will NOT be       ="
	    echo "= included in any image created from this one using 'commit'   ="
	    echo "= or export. You will be responsible about backing up its      ="
	    echo "= content. If you remove the container, the changes made in    ="
	    echo "= the OS image will be gone.                                   ="
	    echo "= If you are OK with this behaviour, define the environment    ="
	    echo "= variable SIMH_USE_CONTAINER with the value 'yes' and create  ="
	    echo "= the container again.                                         ="
	    echo "= if not, please mount a local directory under /machines       ="
	    echo "= and it will be provided with the initial OS image for you.   ="
	    echo "================================================================"
	    exit
	fi
    else
	echo "Empty user container, providing initial OS image..."
	cp -v /image/* .
	echo "Uncompressing OS image file..."
	gunzip $OSIMAGE.gz
	echo "OS image file uncompressed, starting simulator."
	exec $SIMULATOR
    fi
fi
