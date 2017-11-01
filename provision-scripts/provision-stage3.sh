#!/bin/bash

echo "`date` --BEGIN-- Provision Stage 3 Script" >>/root/lsprovision.log
echo "********************************************************************************************"
	echo "`date` -- Populating Student Desktop" >>/root/lsprovision.log
	echo -n "The IP address for the migrate-host is: " >> /home/student/Desktop/migrate-host.txt
	for mac in `virsh domiflist migrate-host |grep -o -E "([0-9a-f]{2}:){5}([0-9a-f]{2})"` ; do arp -e |grep $mac  |grep -o -P "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" ; done >> /home/student/Desktop/migrate-host.txt
	echo "You may login with the username: root and password: Microsoft ">> /home/student/Desktop/migrate-host.txt
	chown student:student /home/student/Desktop/migrate-host.txt
echo "********************************************************************************************"
echo "`date` --END-- Provision Stage 3 Script" >>/root/lsprovision.log

