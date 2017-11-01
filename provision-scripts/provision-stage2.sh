#!/bin/bash

echo "`date` --BEGIN-- Provision Stage 2 Script" >>/root/lsprovision.log
echo "********************************************************************************************"
	echo "`date` -- Creating migrate-host nested virtual machine" >>/root/lsprovision.log
	virt-install --name migrate-host --ram 4096 --disk path=/var/lib/libvirt/images/migrate-host.qcow,format=qcow2,size=10,bus=scsi --location=/var/lib/libvirt/images/CentOS-7-x86_64-Minimal-1708.iso --hvm --vcpus 2 --os-type linux --os-variant centos7.0 --network network=default --nographics --noreboot --initrd-inject=/var/lib/libvirt/images/migrate-host-ks.cfg --extra-args 'console=ttyS0,115200n8 serial ks=file:/migrate-host-ks.cfg'

        while true; do
           if [ -n "$(virsh domstats migrate-host | grep block.1.path |grep Minimal)" ]; then
             echo -n "." >> /root/lsprovision.log
             sleep 10
           else
             echo " " >> /root/lsprovision.log
             break
           fi
        done

	echo "`date` -- Nested VM install complete" >>/root/lsprovision.log
        sleep 10
        echo "`date` -- Configuring VM autostart" >>/root/lsprovision.log
	virsh autostart migrate-host
        echo "`date` -- Starting Nested VM" >>/root/lsprovision.log
	virsh start migrate-host
	echo "`date` -- VM install complete. Sleeping to determine IP address and populating student desktop" >> /root/lsprovision.log
echo "********************************************************************************************"
echo "`date` --END-- Provision Stage 2 Script" >>/root/lsprovision.log

