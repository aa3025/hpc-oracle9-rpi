#!/bin/bash

rm -rf /etc/firewalld/zones
rm -f /etc/firewalld/direct.xml

iptables -X
iptables -F
iptables -Z


systemctl restart firewalld
