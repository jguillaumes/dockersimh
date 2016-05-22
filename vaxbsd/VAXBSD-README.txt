Welcome to the containerized BSD VAX 4.3 for VAX 11/780!

This file describes the initial (as shipped) OS configuration.

KERNEL
======

The default kernel is tailored to be run under a vax 11/780 or vax 8600 
simulator. In both cases, the system disk should be MSCP based ("RA" 
type). The container comes with a "user defined" RA81 disk

The simulator is booted using the file boot43, which is the same the original
PDP-11 based console would use to boot a real 780. To control the boot, the
registers r1Â0 and r11 are used. r10 must contain the major device id of the
boot disk (9 for an MSCP disk), and r11 contains the boot flags. The value coded
in the configuration file (0) produces an autoboot. 1 would stop at the boot
prompt (useful to test new kernels, answer with ra(0,0)vmunix to boot the
default), and 2 would stop at single user. The values are additive, so '3' 
stops at the boot prompt AND boots in single user mode.

The kernel has been tailored to be used with the configuration supplied. You
can modify, of course, this configuration and generate a new kernel. The configuration
used is in /sys/conf/DOKVAX (if you have got the -src image).


NETWORKING
==========

The image starts networking and configures the default device, ne0 or qe0 
depending on if it has been booted using the vax or the vax8600 simulator. 
It should work out of the box, provided your docker container has 
connectivity.

The network interface (qe0 or de0, depending on the simulator you are running)
is configured statically with these parameters:

- Address: 172.17.0.103 / 16
- Gateway: 172.17.0.1
- DNS Servers: Not configured
- Hostname: vaxbsd

You should AT LEAST change the IP address to avoid potential collisions if you
create more than one container. The configuration is in the files

/etc/hosts
/etc/networks
/etc/rc.local
/etc/resolv.conf

The default route (and, actually, the subnet) will be OK if you are using the
default docker container network settings. 

The TELNET and FTP servers are enabled. You may want to disable them in
/etc/inetd.conf, but BSD 4.3 does not come with a SSH server. Different times...


SOFTWARE
========

I have installed some software from /usr/contrib. To be specific, you will find 
in /usr/new the binaries for the jove editor, the kermit comms program and RCS.

There are too two programs you could find useful:

/usr/local/bin/hora: Lets you set up the date and time, Y2K-aware.
		     /usr/local/bin/hora YYYY MM DD HH mm ZZ S
		     ZZ is the offset from GMT, westerly (for CET is -60)
		     S is the DST indicator (1: DST enable)
		     The time must be UTC

/usr/local/bin/zeros: Creates a file full of zeroes until it runs out of disk space
                     It is useful to clean up the space marked as empty so gzip will
		     compress it out (to archive or copy a system image)

The corresponding sources are in /usr/local/src

SOURCES
=======

There are two different images. The one which has "src" in the tag comes with the
system source in a second disk image. The other one does not include the sources.

BASIC ADMINISTRATION
====================

This is an ancient UNIX. You are, basically, on your own. Use 'vipw' to modify
the master users file, and edit /etc/group manually at your leisure. You will have to 
set up manually the user directories. And remember a normal user can not 'su root' unless
he or she is a member of the 'wheel' group.
