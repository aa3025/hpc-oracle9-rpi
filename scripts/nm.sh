#!/bin/bash
# in case we do not have network, but have dvd and need to reinstall NetworkManager

yum install /var/www/html/OL8/BaseOS/Packages/NetworkManager-1.14.0-14.el8.x86_64.rpm /var/www/html/OL8/BaseOS/Packages/NetworkManager-libnm-*.x86_64.rpm /var/www/html/OL8/BaseOS/Packages/libndp-*.x86_64.rpm -y
