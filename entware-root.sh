#!/bin/sh 

echo "Preparing Zyxel for Entware..."
echo "Script by Superpippo82xxx"

#Mount fs RW
mount -n -o remount,rw /
#Remove link for bugged wget
mv /bin/wget /bin/wget_
mv /tmp/wget* /bin/
cp /etc/profile /etc/profile_ori
mv /tmp/profile /etc/profile
echo 'export PATH=/opt/bin:/opt/sbin:"PATH "' >> /etc/profile
mv /tmp/entware.sh /etc/init.d
echo '#Entware Startup script by Superpippo82xxx' >> /etc/init.d/rcS
echo '/data/entware.sh &' >> /etc/init.d/rcS
#Mount fs RO
mount -n -o remount,ro /
#Create entware.sh
echo '#! /bin/sh' >> /data/entware.sh
echo 'sleep 3m' >> /data/entware.sh
echo 'mount /home/root/usb1_sda1/opt /opt' >> /data/entware.sh
echo '/opt/etc/init.d/rc.unslung start' >> /data/entware.sh
chmod +x /data/entware
cd /tmp/
wget -O http://bin.entware.net/armv7sf-k3.2/installer/generic.sh | sh
