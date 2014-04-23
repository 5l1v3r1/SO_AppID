#!/bin/bash
#	
#	Start with a fresh install of Security Onion 12.04.4 post-setup.
#
# 	Prerequisite files. Download them from snort.org
# 	snort-openappid-detectors.2014-02-22.187-0.tgz
# 	snort-2.9.7.0_alpha.tar.gz
#	daq-2.0.2.tar.gz
#	snortrules-snapshot-2960.tar.gz
#
#	Create the directory ~/snortapps/ and put the files above into this folder. There are two additional files that download below, download them yourself and comment out the wget.
#	Then run the script. Have fun with openappid!
#	To run snort with the new DataAQuisitionlibrary (http://vrt-blog.snort.org/2010/08/snort-29-essentials-daq.html) 
#	try: sudo snort -c /etc/snort/snort.conf --daq afpacket -i eth0 -k none
#	To check the logs use "/usr/bin/local/u2openappid"    example ./u2openappid /var/appstats-unified.log.1298258241
#
#	This script is for test purposes only. It disables the NSM service.  Don't blame me if your production environment crashes!
#	I pulled some of these ideas from the blogs on blog.snort.org 
#
#	Steve Borosh steveborosh@cybersecuritystrategies.co | rvrsh3ll on freenode irc
##############################################################################################################################################
apt-get remove securityonion-snort
apt-get install openssl libssl-dev build-essential g++ flex bison zlib1g-dev autoconf libtool libpcap-dev libpcre3-dev libdumbnet-dev build-essential
wget http://prdownloads.sourceforge.net/libdnet/libdnet-1.11.tar.gz # comment this out if you download it and place it into ~/snortapps/
wget http://luajit.org/download/LuaJIT-2.0.2.tar.gz	# comment this out if you download it and place it into ~/snortapps/
tar zxvf libdnet-1.11.tar.gz
cd libdnet-1.11/
./configure
make
make install
cd ~/snortapps/
tar -zxvf LuaJIT-2.0.2.tar.gz
cd LuaJIT-2.0.2/
make
make install
cd ~/snortapps/
tar -zxvf daq-2.0.2.tar.gz
cd daq-2.0.2/
./configure
make
make install
ldconfig
cd ~/snortapps/
tar -zxvf snort-2.9.7.0_alpha.tar.gz
cd snort-2.9.7.0.alpha/
./configure --enable-sourcefire --enable-open-appid
make
make install
cd ~/snortapps/
mkdir /usr/local/lib/openappid
tar -zxvf snort-openappid-detectors.2014-02-22.187-0.tgz
rsync -a odp/ /usr/local/lib/openappid/odp/
mkdir /etc/snort
mkdir /var/log/snort
mkdir /usr/local/lib/snort_dynamicrules
mkdir /etc/snort/rules
touch /etc/snort/white_list.rules
touch /etc/snort/black_list.rules
cd ~/snortapps/snort-2.9.7.0.alpha/etc/
cp attribute_table.dtd file_magic.conf snort.conf unicode.map classification.config gen-msg.map reference.config threshold.conf /etc/snort/
sed -i 's|dynamicdetection|#dynamicdetection|' /etc/snort/snort.conf
sed -i 's|var RULE_PATH ../rules|var RULE_PATH /etc/snort/rules|' /etc/snort/snort.conf
sed -i 's|var SO_RULE_PATH ../so_rules|var SO_RULE_PATH /etc/snort/so_rules|' /etc/snort/snort.conf
sed -i 's|var PREPROC_RULE_PATH ../preproc_rules|var PREPROC_RULE_PATH /etc/snort/preproc_rules|' /etc/snort/snort.conf
sed -i 's|var WHITE_LIST_PATH ../rules|var WHITE_LIST_PATH /etc/snort|' /etc/snort/snort.conf
sed -i 's|var BLACK_LIST_PATH ../rules|var BLACK_LIST_PATH /etc/snort|' /etc/snort/snort.conf
sed -i '/black_list.rules/a\preprocessor appid : app_stats_filename appstats-unified.log, app_stats_period 60, app_detector_dir /usr/local/lib/openappid\' /etc/snort/snort.conf
sed -i '/vlan_event_types/ a\output unified2: filename snort.log, limit 128, appid_event_types \' /etc/snort/snort.conf
sed -i 's/^[ \t]*//' /etc/snort/snort.conf
cd ~/snortapps/
tar -zxvf snortrules-snapshot-2960.tar.gz
cp -r preproc_rules /etc/snort
cp -r rules /etc/snort
cp -r so_rules /etc/snort

echo "Ready to run Snort!"

exit 0


