#!/bin/bash

echo "`date` --BEGIN-- Provision Stage 1 Script" >>/root/lsprovision.log
echo "********************************************************************************************"
	echo "`date` -- Creating Student User" >>/root/lsprovision.log
	useradd student
echo "********************************************************************************************"
	echo "`date` -- Setting Student User password to 'Microsoft'" >>/root/lsprovision.log
	echo "Microsoft" | passwd --stdin student
echo "********************************************************************************************"
	echo "`date` -- Adding student to wheel group for sudo access'" >>/root/lsprovision.log
	usermod -G wheel student
echo "********************************************************************************************"
	echo "`date` -- Setting Root Password to 'Microsoft'" >>/root/lsprovision.log
	echo "Microsoft" | passwd --stdin root
echo "********************************************************************************************"
	echo "`date` -- Creating required logical volumes" >>/root/lsprovision.log
	lvcreate -n libvirtlv -L+20G rootvg
	mkfs -t ext4 /dev/rootvg/libvirtlv
	echo "/dev/mapper/rootvg-libvirtlv /var/lib/libvirt    ext4     defaults       0 0" >> /etc/fstab 
        mkdir -p /var/lib/libvirt
	mount -a
echo "********************************************************************************************"
	echo "`date` -- Adding 'deltarpm' and other required RPMs" >>/root/lsprovision.log
	yum -y install deltarpm epel-release
	yum -y install policycoreutils-python libsemanage-devel gcc gcc-c++ kernel-devel python-devel libxslt-devel libffi-devel openssl-devel python2-pip iptables-services
echo "********************************************************************************************"
	echo "`date` -- Securing host and changing default SSH port to 2112" >>/root/lsprovision.log
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
	echo "`date` -- Adding package elements to enable nested virtualization" >>/root/lsprovision.log
	yum groups mark convert
	yum -y groupinstall "Virtualization Host"
	yum -y install virt-manager virt-install virt-viewer
echo "********************************************************************************************"
	echo "`date` -- Adding package elements to enable graphical interface" >>/root/lsprovision.log
	yum -y groupinstall "Server with GUI"
echo "********************************************************************************************"
	echo "`date` -- Setting default systemd target to graphical.target" >>/root/lsprovision.log
	systemctl set-default graphical.target
echo "********************************************************************************************"
	echo "`date` -- Enabling and starting libvirtd" >>/root/lsprovision.log
	systemctl enable libvirtd
	systemctl start libvirtd
echo "********************************************************************************************"
        echo "`date` -- Copying the VM rebuild script to the host" >> /root/lsprovision.log
        wget --quiet -P /var/lib/libvirt/images https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/rebuild-migrate-host.sh
        chmod 755 /var/lib/libvirt/images/rebuild-migrate-host.sh
echo "********************************************************************************************"
	echo "`date` -- Installing noVNC environment" >>/root/lsprovision.log
	yum -y install novnc python-websockify numpy tigervnc-server
        wget --quiet -P /etc/systemd/system https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/websockify.service
	wget --quiet --no-check-certificate -P /etc/systemd/system "https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/vncserver@:4.service"
	openssl req -x509 -nodes -newkey rsa:2048 -keyout /etc/pki/tls/certs/novnc.pem -out /etc/pki/tls/certs/novnc.pem -days 365 -subj "/C=US/ST=Michigan/L=Ann Arbor/O=Lift And Shift/OU=Lift And Shift/CN=stkirk.cloud"
	su -c "mkdir .vnc" - student
	wget --quiet --no-check-certificate -P /home/student/.vnc https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/passwd
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
	echo "`date` -- Downloading CentOS ISO from wolverine server" >>/root/lsprovision.log
	wget --quiet --no-check-certificate -P /var/lib/libvirt/images https://wolverine.itscloudy.af/liftshift/CentOS-7-x86_64-Minimal-1708.iso
        wget --quiet -P /var/lib/libvirt/images https://raw.githubusercontent.com/stuartatmicrosoft/Azure-Linux-Migration-Workshop/master/provision-scripts/migrate-host-ks.cfg
        chown qemu:qemu /var/lib/libvirt/images/*
        restorecon -rv /var/lib/libvirt/images/*
echo "`date` --END-- Provision Stage 1 Script" >>/root/lsprovision.log
