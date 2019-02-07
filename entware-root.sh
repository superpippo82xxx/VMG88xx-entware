#!/bin/sh 

echo "Preparing Zyxel for Entware..."
echo "Script by Superpippo82xxx"

#Mount fs RW
mount -n -o remount,rw /

#Remove link for bugged wget
if [ -f /bin/wget-ssl ]; then
   echo "Wget already patched"
else
   echo "Going to patch wget"
   mv /bin/wget /bin/wget_
	curl -k -L https://github.com/superpippo82xxx/VMG88xx-entware/raw/master/wget-ssl -o /tmp/wget-ssl
	mv /tmp/wget-ssl /bin/
	chmod +x /bin/wget-ssl
	ln -s  /bin/wget-ssl /bin/wget
fi
if [ -f /etc/profile_ori ]; then
   echo "/etc/profile already patched"
else
	cp /etc/profile /etc/profile_ori
	echo 'export PATH=/opt/bin:/opt/sbin:$PATH' >> /etc/profile
fi

if grep -xq "/data/entware.sh &" /etc/init.d/rcS ; then
   echo "/etc/init.d/rcS already patched"
else
	echo '#Entware Startup script by Superpippo82xxx' >> /etc/init.d/rcS
	echo '/data/entware.sh &' >> /etc/init.d/rcS
fi

if grep -xq "/data/firewall.sh &" /etc/init.d/rcS ; then
   echo "/etc/init.d/rcS already patched "
else
	echo '#Firewall custom Startup script by Superpippo82xxx' >> /etc/init.d/rcS
	echo '/data/firewall.sh &' >> /etc/init.d/rcS
fi

#Mount fs RO
mount -n -o remount,ro /
#Create entware.sh
if [ -f /data/entware.sh ]; then
   echo "/data/entware.sh already created"
else
	echo '#! /bin/sh' >> /data/entware.sh
	echo 'sleep 3m' >> /data/entware.sh
	echo 'mount /home/root/usb1_sda1/opt /opt' >> /data/entware.sh
	echo '/opt/etc/init.d/rc.unslung start' >> /data/entware.sh
	chmod +x /data/entware.sh
fi
if [ -f /data/firewall.sh ]; then
   echo "/data/firewall.sh already created"
else	
	echo '#! /bin/sh' >> /data/firewall.sh
	echo 'sleep 3m' >> /data/firewall.sh
	echo '#apro ssh entware' >> /data/firewall.sh
	echo 'iptables -A INPUT_GENERAL -i  br+ -p tcp -m tcp --dport 22 -j ACCEPT' >> /data/firewall.sh
	chmod +x /data/firewall.sh
fi
cd /tmp/
if [ ! -d "/home/root/usb1_sda1/opt" ]; then
	mkdir /home/root/usb1_sda1/opt
fi
mount /home/root/usb1_sda1/opt /opt
wget http://bin.entware.net/armv7sf-k3.2/installer/alternative.sh 
sh /tmp/alternative.sh
opkg update
opkg install dropbear
/opt/etc/init.d/rc.unslung start
echo 'Se tutto è andato bene puoi collegarti al router in ssh con password di root 12345'
echo 'Mi raccomando cambiala subito!!'
