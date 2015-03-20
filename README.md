Upgrade Security Onion 12.04.4 to use openappid



Start with a fresh install of Security Onion 12.04.4 post-setup.

Prerequisite files. Download them from snort.org
snort-openappid-detectors.2014-02-22.187-0.tgz
snort-2.9.7.0_alpha.tar.gz
daq-2.0.2.tar.gz
snortrules-snapshot-2960.tar.gz

Create the directory ~/snortapps/ and put the files above into this folder. There are two additional files that download below, download them yourself and comment out the wget.
Then run the script.

To run snort with the new DataAQuisitionlibrary (http://vrt-blog.snort.org/2010/08/snort-29-essentials-daq.html) 
try: sudo snort -c /etc/snort/snort.conf --daq afpacket -i eth0 -k none

To check the logs use "/usr/bin/local/u2openappid"    example ./u2openappid /var/appstats-unified.log.1298258241


This script is for test purposes only. It disables the NSM service.  Don't blame me if your production environment crashes!
I pulled some of these ideas from the blogs on blog.snort.org 