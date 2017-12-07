#!/bin/bash

virsh destroy migrate-host
virsh undefine migrate-host
rm -f /var/lib/libvirt/images/migrate-host.qcow

virt-install --name migrate-host --ram 4096 --disk path=/var/lib/libvirt/images/migrate-host.qcow,format=qcow2,size=10,bus=scsi --location=/var/lib/libvirt/images/CentOS-7-x86_64-Minimal-1708.iso --hvm --vcpus 2 --os-type linux --os-variant centos7.0 --network network=default --nographics --noreboot --initrd-inject=/var/lib/libvirt/images/migrate-host-ks.cfg --extra-args 'console=ttyS0,115200n8 serial ks=file:/migrate-host-ks.cfg'

virsh autostart migrate-host
virsh start migrate-host
sleep 10
for mac in `virsh domiflist migrate-host |grep -o -E "([0-9a-f]{2}:){5}([0-9a-f]{2})"` ; do arp -e |grep $mac  |grep -o -P "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" ; done

