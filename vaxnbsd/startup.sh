#!/bin/sh 

OSIMAGE=RAUSER000.vhd
PKGIMAGE=RAUSER001.vhd
USRIMAGE=RAUSER002.vhd
EMPIMAGE=RAUSEREMP.vhd.gz
SIMULATOR=vax8600
CONTSHELL="busybox sh"

unpackstuff () {
    if [ ! -f $1 ]; then
	echo "Uncompressing $2..."
	gunzip $1.gz
    fi
}

provide_empty () {
    if [ ! -f $1 ]; then
	echo "Providing empty $2..."
	cp $3 $1.gz
	gunzip $1.gz
    fi
}
    
provision_and_run () {
    cp -v /image/* .
    unpackstuff $OSIMAGE "OS image file"
    provide_empty $PKGIMAGE "/usr/pkgsrc disk" $EMPIMAGE
    provide_empty $USRIMAGE "/usr/src disk" $EMPIMAGE
    if [ -f $OSIMAGE -a -f $PKGIMAGE -a -f $USRIMAGE ]; then
	echo "All images uncompressed, starting simulator..."
	exec $SIMULATOR
    else
	echo "Some images are still missing... Dropping to shell."
	exec $CONTSHELL
    fi
}

cd /machines

if [ -f $OSIMAGE -a -f $PKGIMAGE -a -f $USRIMAGE ]; then
	echo "Found uncompressed OS image file, starting simulator."
	exec $SIMULATOR
else
    if [ -f original-content ]; then
	if [ "$SIMH_USE_CONTAINER" == "yes" ]; then
	    echo "SIMH_USE_CONTAINER=$SIMH_USE_CONTAINER, using container storage"
	    echo "Copying distribution files..."
	    provision_and_run
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
	provision_and_run
    fi
fi
