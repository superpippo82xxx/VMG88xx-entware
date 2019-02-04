#!/bin/sh 

echo "Preparing Zyxel for Entware..."
echo "Script by Superpippo82xxx"

#Mount fs RW
mount -n -o remount,rw /

#Remove link for bugged wget
mv /bin/wget /bin/wget_
curl -k -L https://github.com/superpippo82xxx/VMG88xx-entware/raw/master/wget-ssl -o /tmp/wget-ssl
mv /tmp/wget-ssl /bin/
chmod +x /bin/wget-ssl
ln -s /bin/wget /bin/wget-ssl
cp /etc/profile /etc/profile_ori
echo 'export PATH=/opt/bin:/opt/sbin:$PATH' >> /etc/profile
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
