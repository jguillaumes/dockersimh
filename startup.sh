#!/bin/bash

#/usr/sbin/tunctl -t tap0
#/usr/bin/vde_switch --mode 666 --numports 8 -mgmt /tmp/vde.mgmt --mgmtmode 666 -s /tmp/vde.ctl -t tap1 --daemon 
#/sbin/brctl addbr br0
#/sbin/brctl addif br0 eth0
#/sbin/brctl addif br0 tap0
#ifconfig eth0 promisc

if [ "$1" != "" ]; then
	exec "$1"
else
   exec bash
fi

