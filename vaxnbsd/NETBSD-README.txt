Welcome to the containerized NetBSD VAX 6.1.5!

This file describes the initial (as shipped) OS configuration.

KERNEL
======

The default kernel is tailored to be run under a vax 11/780 or vax 8600 
simulator. In both cases, the system disk should be MSCP based ("RA" 
type). The container comes with a "user defined" 2GB disk.

There are four kernel files at the root directory:

/netbsd		The default one, tailored to boot under a VAX 8600
/netbsd.8600	A copy of the default netbsd
/netbsd.3900	A kernel tailored to boot under a MicroVAX 3900
/netbsd.generic The "GENERIC" kernel distributed in NetBSD

The default container configuration uses the 8600 simulator. You can boot 
the image using the "vax" (microvax 3900) simulator using the netbsd.3900 
or the netbsd.generic kernels.

The configuration files used to build netbsd.8600 and netbsd.3900 are in this
same directory (/root) as VAX8600 and MV3900. If you grab a copy of the source
you can copy them to /usr/src/sys/arch/vax/conf and proceed from there.

NETWORKING
==========

The image starts networking and configures the default device, ne0 or qe0 
depending on if it has been booted using the vax or the vax8600 simulator. 
It should work out of the box, provided your docker container has 
connectivity.

The network interface (qe0 or de0, depending on the simulator you are running)
is configured statically with these parameters:

- Address: 172.17.0.200 / 16
- Gateway: 172.17.0.1
- DNS Servers: 8.8.8.8 and 8.8.4.4 (Google public DNS servers)
- Hostname: vaxnbsd615

You should AT LEAST change the IP address to avoid potential collisions if you
create more than one container. The configuration is in the files

/etc/ifconfig.de0
/etc/ifconfig.qe0

The default route (and, actually, the subnet) will be OK if you are using the
default docker container network settings. If you need to change it, refer
to the file:

/etc/mygate

Those parameters can be set up alternatively in /etc/rc.conf

The SSH server is disabled (it is really slow under a VAX simulator). The
TELNET and FTP servers are enabled. You may want to disable them in
/etc/inetd.conf. To enable SSHD modify /etc/rc.conf


SOFTWARE
========

There are some installed packages, including some editors. Use the command 
pkg_info to find what's here.

SOURCES
=======

Neither the system nor the PKGSRC sources are included. The /usr/src and 
/usr/pkgsrc directories have been created, and the /etc/fstab file 
contains commented out entries to mount additional storage to contain the 
sources. You will have to install them yourself.

BASIC ADMINISTRATION
====================

To add an user:

# useradd -m username

To make an user administrator (so he can do 'su'):

# usermod -G wheel username


