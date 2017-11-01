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
        wget --quiet -P /etc/systemd/system https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/websockify.service
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
        wget --quiet -P /var/lib/libvirt/images https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/migrate-host-ks.cfg
        chown qemu:qemu /var/lib/libvirt/images/*
        restorecon -rv /var/lib/libvirt/images/*

