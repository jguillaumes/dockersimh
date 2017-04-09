#!/bin/sh


if [[ "$VDEPLUG_PWD" != "" ]]; then
    echo "*** Changing vdeplug password as specified by VDEPLUG_PWD ***"
    echo "vdeuser:$VDEPLUG_PWD" | chpasswd
fi

chown vdeplug /vde.ctl
chown vdeplug /vde.mgmt

ssh-keygen -A

/usr/sbin/sshd -e "$@"

echo "=============================================================="
echo "= Starting VDE virtual switch                                ="
echo "= The Virtual Switch will use the volume /vde.ctl as comm    ="
echo "= socket dir and /vde.mgmt as management socket.             ="
echo "= The connected VMs must import that volume                  ="
echo "=============================================================="
su vdeplug -c "vde_switch --sock /vde.ctl --mgmt /vde.mgmt --daemon"


echo "=============================================================="
echo "= Starting VDE cryptcab plug                                 ="
echo "= To connect to this VDE switch you can use vde_cryptcab     ="
echo "= specify -c vdeplug@dockerhost:$YOUR_7667_PORTMAP in the    ="
echo "= vde_cryptcab command line.                                 ="
echo "= You need to export SCP_EXTRA_OPTIONS="-P $YOUR_22_PORTMAP" ="
echo "= to allow scp to work. Use the ports to which you mapped    ="
echo "= the 7667 and 22 container ports respectively.              ="
echo "=============================================================="
su vdeplug -c "vde_cryptcab -s /vde.ctl"
