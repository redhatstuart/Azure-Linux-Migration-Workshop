#!/bin/bash

echo "********************************************************************************************"
	echo "Creating Student User"
	useradd student
echo "********************************************************************************************"
	echo "Setting Student User password to 'Microsoft'"
	echo "Microsoft" | passwd --stdin student
echo "********************************************************************************************"
	echo "Setting Root Password to 'Microsoft'"
	echo "Microsoft" | passwd --stdin root
echo "********************************************************************************************"
	echo "Creating required logical volumes"
	lvcreate -n libvirtlv -L+20G rootvg
	mkfs -t ext4 /dev/rootvg/libvirtlv
	echo "/dev/mapper/rootvg-libvirtlv /var/lib/libvirt    ext4     defaults       0 0" >> /etc/fstab 
        mkdir -p /var/lib/libvirt
	mount -a
echo "********************************************************************************************"
	echo "Adding 'deltarpm' and other required RPMs"
	yum -y install deltarpm epel-release
	yum -y install policycoreutils-python libsemanage-devel gcc gcc-c++ kernel-devel python-devel libxslt-devel libffi-devel openssl-devel python2-pip iptables-services
echo "********************************************************************************************"
	echo "Securing host and changing default SSH port to 2112"
	sed -i "s/dport 22/dport 2112/g" /etc/sysconfig/iptables
	semanage port -a -t ssh_port_t -p tcp 2112
	sed -i "s/#Port 22/Port 2112/g" /etc/ssh/sshd_config
	systemctl restart sshd
	systemctl stop firewalld
	systemctl disable firewalld
	systemctl mask firewalld
	systemctl enable iptables
	systemctl start iptables
echo "********************************************************************************************"
	echo "Adding package elements to enable nested virtualization"
	yum groups mark convert
	yum -y groupinstall "Virtualization Host"
	yum -y install virt-manager virt-install virt-viewer
echo "********************************************************************************************"
	echo "Adding package elements to enable graphical interface"
	yum -y groupinstall "Server with GUI"
echo "********************************************************************************************"
	echo "Setting default systemd target to graphical.target"
	systemctl set-default graphical.target
echo "********************************************************************************************"
	echo "Enabling and starting libvirtd"
	systemctl enable libvirtd
	systemctl start libvirtd
echo "********************************************************************************************"
	echo "Installing noVNC environment"
	yum -y install novnc python-websockify numpy tigervnc-server
	wget --quiet --no-check-certificate -P /etc/systemd/system https://wolverine.itscloudy.af/liftshift/websockify.service
	wget --quiet --no-check-certificate -P /etc/systemd/system "https://wolverine.itscloudy.af/liftshift/vncserver@:4.service"
	openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/pki/tls/certs/novnc.pem -out /etc/pki/tls/certs/novnc.pem -days 365 -subj "/C=US/ST=Michigan/L=Ann Arbor/O=Lift And Shift/OU=Lift And Shift/CN=stkirk.cloud"
	su -c "mkdir .vnc" - student
	wget --quiet --no-check-certificate -P /home/student/.vnc https://wolverine.itscloudy.af/liftshift/passwd
        chown student:student /home/student/.vnc/passwd
        chmod 600 /home/student/.vnc/passwd
	iptables -I INPUT 1 -m tcp -p tcp --dport 6080 -j ACCEPT
	service iptables save
        systemctl daemon-reload
        systemctl enable vncserver@:4.service
        systemctl enable websockify.service
        systemctl start vncserver@:4.service
	systemctl start websockify.service
echo "********************************************************************************************"
	echo "Downloading CentOS ISO from wolverine server"
	wget --quiet --no-check-certificate -P /var/lib/libvirt/images https://wolverine.itscloudy.af/liftshift/CentOS-7-x86_64-Minimal-1708.iso
	wget --quiet --no-check-certificate -P /var/lib/libvirt/images https://wolverine.itscloudy.af/liftshift/migrate-host-ks.cfg
        chown qemu:qemu /var/lib/libvirt/images/*
        restorecon -rv /var/lib/libvirt/images/*
echo "********************************************************************************************"
	echo "Creating migrate-host nested virtual machine"
	virt-install --name migrate-host --ram 4096 --disk path=/var/lib/libvirt/images/migrate-host.qcow,format=qcow2,size=10,bus=scsi --location=/var/lib/libvirt/images/CentOS-7-x86_64-Minimal-1708.iso --hvm --vcpus 2 --os-type linux --os-variant centos7.0 --network network=default --nographics --noreboot --console pty,target_type=serial --initrd-inject=/var/lib/libvirt/images/migrate-host-ks.cfg --extra-args 'console=ttyS0,115200n8 serial ks=file:/migrate-host-ks.cfg'
	virsh autostart migrate-host
	virsh start migrate-host
	echo "VM install complete. Sleeping to determine IP address and populating student desktop"
	sleep 10
	echo -n "The IP address for the migrate-host is: " >> /home/student/Desktop/migrate-host.txt
	for mac in `virsh domiflist migrate-host |grep -o -E "([0-9a-f]{2}:){5}([0-9a-f]{2})"` ; do arp -e |grep $mac  |grep -o -P "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" ; done >> /home/student/Desktop/migrate-host.txt
	echo "You may login with the username: root and password: Microsoft ">> /home/student/Desktop/migrate-host.txt
	chown student:student /home/student/Desktop/migrate-host.txt
echo "********************************************************************************************"













